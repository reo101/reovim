{ lib, config, self, inputs, ... }:

let
  inherit (inputs.self) configFiles;
in
{
  options.reovim = lib.mkOption {
    type = lib.types.submodule {
      options = {
        lockfilePath = lib.mkOption {
          type = lib.types.path;
          default = "${self}/nvim-pack-lock.json";
          description = "Path to the nvim-pack-lock.json file";
        };

        configDirectory = lib.mkOption {
          type = lib.types.path;
          default = self;
          description = "Path to the Neovim config directory";
        };

        package = lib.mkOption {
          type = lib.types.functionTo lib.types.unspecified;
          description = "The Neovim package to use";
          default = pkgs: pkgs.neovim;
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.unspecified;
          default = [];
          description = "Extra packages to include with the wrapper";
        };

        fennelPackage = lib.mkOption {
          type = lib.types.nullOr lib.types.unspecified;
          default = null;
          description = "Fennel package to use (must have #_ discard support). If null, uses inputs'.rix101.packages.fennel";
        };
      };
    };
    default = {};
  };

  config = {
    perSystem = { lib, pkgs, system, inputs', ... }: let
      fennelPackage = if config.reovim.fennelPackage != null
        then config.reovim.fennelPackage
        else inputs'.rix101.packages.fennel;
      fs = lib.fileset;
      neovimPkgs = pkgs.extend inputs.neovim-nightly-overlay.overlays.default;

      # Import library functions (evaluated, not built)
      lockfileLib = import ../lib/lockfile.nix { pkgs = neovimPkgs; inherit lib; };
      treesitterLib = import ../lib/treesitter.nix { pkgs = neovimPkgs; inherit lib; };

      neovimPackage = config.reovim.package neovimPkgs;

      # Create a source derivation for the config files
      rawConfigSource = fs.toSource {
        root = ./../..;
        fileset = configFiles;
      };

      # Pre-compile Fennel files at build time using existing .nfnl.fnl config
      # Uses REOVIM_NIX_BUILD env var to force all output to lua/ directory
      configSource = pkgs.stdenv.mkDerivation {
        name = "reovim-config-with-compiled-lua";
        src = rawConfigSource;
        nativeBuildInputs = [ neovimPkgs.neovim fennelPackage ];
        buildPhase = ''
          cp -r $src/. .
          chmod -R +w .

          export HOME=$TMPDIR
          # Enable nix build mode - .nfnl.fnl checks this to output to lua/ instead of data/nfnl/
          export REOVIM_NIX_BUILD=1

          # Find all Fennel files to compile
          echo "=== Fennel files to compile ==="
          find . -name "*.fnl" -type f | grep -v "^\\./lua/" | sort
          echo ""

          # Compile all Fennel files using nfnl.api
          # Create a temporary init script for the build that:
          # 1. Sets up paths for nfnl
          # 2. Trusts .nfnl.fnl
          # 3. Compiles all files and captures errors
          cat > /tmp/nfnl-build-init.lua << 'LUA'
          -- Add nfnl to package.path
          package.path = "${neovimPkgs.vimPlugins.nfnl}/lua/?.lua;" .. package.path
          -- Trust .nfnl.fnl by loading it into a buffer and calling trust
          local nfnl_config_path = vim.fn.getcwd() .. "/.nfnl.fnl"
          if vim.fn.filereadable(nfnl_config_path) == 1 then
            local bufnr = vim.fn.bufadd(nfnl_config_path)
            vim.bo[bufnr].swapfile = false
            vim.fn.bufload(bufnr)
            pcall(vim.secure.trust, {bufnr = bufnr, action = "allow"})
          end
          -- Compile all fennel files and capture results
          local nfnl_api = require("nfnl.api")
          local results = nfnl_api["compile-all-files"]('.')
          -- Write results to file for analysis
          local result_file = io.open('/tmp/nfnl-compile-results.lua', 'w')
          if result_file then
            result_file:write(vim.inspect(results))
            result_file:close()
          end
          -- Count errors and not-ok results
          -- Results can be either a list or a map depending on nfnl version
          local error_count = 0
          local total_count = 0
          if type(results) == "table" then
            for k, v in pairs(results) do
              total_count = total_count + 1
              -- v.ok may be nil for skipped files, only count explicit false
              if v.ok == false then
                error_count = error_count + 1
                print("ERROR: Failed to compile " .. tostring(k) .. ": " .. tostring(v.err or "unknown error"))
              end
            end
          end
          print("FENNEL_COMPILE_INFO: " .. total_count .. " file(s) processed, " .. error_count .. " error(s)")
          if error_count > 0 then
            print("FENNEL_COMPILE_FAILED: Build aborted due to compilation errors")
            vim.cmd('cq')  -- Use :cq (quit with error) instead of :cquit 1
            -- Fallback if :cq doesn't exit
            os.exit(1)
          else
            print("FENNEL_COMPILE_SUCCESS: All files compiled successfully")
          end
          LUA
          nvim --headless -u /tmp/nfnl-build-init.lua -c 'qall!'
          NVIM_EXIT_CODE=$?
          if [ $NVIM_EXIT_CODE -ne 0 ]; then
            echo ""
            echo "=== Fennel compilation failed with exit code $NVIM_EXIT_CODE ==="
            if [ -f /tmp/nfnl-compile-results.lua ]; then
              echo "=== Compilation results ==="
              cat /tmp/nfnl-compile-results.lua
            fi
            exit 1
          fi

          echo ""
          echo "=== Fennel compilation complete ==="
          if [ $NVIM_EXIT_CODE -ne 0 ]; then
            echo ""
            echo "=== Fennel compilation failed with exit code $NVIM_EXIT_CODE ==="
            if [ -f /tmp/nfnl-compile-results.lua ]; then
              echo "=== Compilation results ==="
              cat /tmp/nfnl-compile-results.lua
            fi
            exit 1
          fi

          echo ""
          echo "=== Compiled Lua files ==="
          find lua -name "*.lua" -type f 2>/dev/null | sort
          echo ""
          echo "Total lua files: $(find lua -name '*.lua' -type f 2>/dev/null | wc -l)"

          # Verify key bootstrap files exist
          echo ""
          echo "=== Verifying bootstrap files ==="
          for f in lua/bootstrap-nfnl.lua lua/fennel-loader.lua; do
            if [ -f "$f" ]; then
              echo "✓ $f exists"
            else
              echo "✗ $f MISSING"
              exit 1
            fi
          done

          # Verify rv-config simple-plugins file (critical for plugin loading)
          echo ""
          echo "=== Verifying rv-config library files ==="
          for f in lua/rv-config/simple-plugins.lua; do
            if [ -f "$f" ]; then
              echo "✓ $f exists"
            else
              echo "✗ $f MISSING - compilation may have failed silently"
              exit 1
            fi
          done

          # Count expected rv-config modules vs actual
          echo ""
          echo "=== rv-config module verification ==="
          fnl_count=$(find fnl/rv-config -name "init.fnl" -o -name "*.fnl" 2>/dev/null | grep -c "\.fnl$" || echo "0")
          lua_count=$(find lua/rv-config -name "*.lua" 2>/dev/null | wc -l)
          echo "Fennel files: $fnl_count, Compiled Lua files: $lua_count"
          if [ "$lua_count" -eq 0 ]; then
            echo "ERROR: No rv-config Lua files found - compilation failed"
            exit 1
          fi

          # Check for specific missing files that should exist
          echo ""
          echo "=== Checking for silently skipped files ==="
          missing=0
          while IFS= read -r fnl_file; do
            # Convert fnl path to expected lua path
            lua_file=$(echo "$fnl_file" | sed 's/^fnl\//lua\//; s/\.fnl$/.lua/')
            if [ ! -f "$lua_file" ]; then
              echo "✗ MISSING: $lua_file (from $fnl_file)"
              missing=$((missing + 1))
            fi
          done < <(find fnl/rv-config -name "*.fnl" 2>/dev/null || true)
          if [ "$missing" -gt 0 ]; then
            echo "ERROR: $missing file(s) were not compiled - build failed"
            exit 1
          fi
        '';
        installPhase = ''
          cp -r . $out
        '';
      };

      # Build treesitter grammars from lockfile
      # Grammars are stored under the "grammars" key in nvim-pack-lock.json
      # Returns list of { name = <name>; lang = <tree_sitter_lang>; drv = <derivation>; }
      treesitterGrammars = treesitterLib.mkTreesitterGrammarsFromLockfile { 
        lockfilePath = config.reovim.lockfilePath;
      };
      
      # Create unified parser directory for all grammars
      parserDir = treesitterLib.mkParserDir { 
        grammars = treesitterGrammars; 
      };
      
      # Build regular plugins, excluding treesitter grammars (handled as grammars, not plugins)
      lockfilePlugins =
        let
          # Get grammar names to exclude from plugins
          grammarNames = map (g: g.name) treesitterGrammars;
          plugins = lockfileLib.mkPluginsFromLockfile { 
            lockfilePath = config.reovim.lockfilePath;
            excludePlugins = grammarNames;
          };
        in
        lib.attrValues plugins;

      # Convert list of plugins to individual specs.
      # When a spec's data is a list, normalize.nix creates children with 'value = child'
      # but allPlugins expects 'v.data'. By making each plugin its own spec with data set,
      # we ensure plugins are correctly recognized.
      lockfilePluginSpecs = lib.listToAttrs (map (plugin: {
        name = plugin.pname or plugin.name or "unknown-plugin";
        value = {
          data = plugin;
          lazy = true;
        };
      }) lockfilePlugins);

      # Create a "plugin" that just contains the parser directory
      # This gets linked into the runtime path where nvim-treesitter can find it
      parserPlugin = pkgs.runCommand "treesitter-parser-plugin" {} ''
        mkdir -p $out
        # Link parser directory - nvim-treesitter looks for parser/*.so in rtp
        ln -s ${parserDir}/parser $out/parser
        # Also link queries if they exist
        if [ -d "${parserDir}/queries" ]; then
          ln -s ${parserDir}/queries $out/queries
        fi
      '';

      # Create spec for the parser plugin - should be in start/ (lazy = false)
      parserPluginSpec = {
        "treesitter-parsers" = {
          data = parserPlugin;
          lazy = false;
        };
      };

      wrapperModule = inputs.nix-wrapper-modules.lib.evalModule [
        { pkgs = lib.mkForce neovimPkgs; }
        inputs.nix-wrapper-modules.lib.wrapperModules.neovim
        {
          config.settings = {
              # Config source - nfnl will compile Fennel files at runtime to stdpath('data')/nfnl/lua/
              config_directory = "${configSource}";
              package = neovimPackage;
              viAlias = true;
              vimAlias = true;
              vimdiffAlias = true;
              infoPluginName = "nix-info-plugin-name";
            };
          config.specs = lockfilePluginSpecs // parserPluginSpec;
          config.extraPackages = [ fennelPackage ] ++ config.reovim.extraPackages;
          # Set NVIM_APPNAME to isolate reovim from user's regular neovim config
          config.env.NVIM_APPNAME = "reovim";
        }
      ];
    in {
      packages = {
        reovim = wrapperModule.config.wrap { inherit pkgs; };
        default = wrapperModule.config.wrap { inherit pkgs; };
      };
    };

    # Add reovim overlay automatically
    flake.overlays.reovim = final: prev: {
      reovim = inputs.self.packages.${final.stdenv.hostPlatform.system}.reovim;
    };
  };
}
