{
  lib,
  config,
  self,
  inputs,
  ...
}:

let
  inherit (self) configFiles;
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
          default = [ ];
          description = "Extra packages to include with the wrapper";
        };

        fennelPackage = lib.mkOption {
          type = lib.types.nullOr lib.types.unspecified;
          default = null;
          description = "Fennel package to use (must have #_ discard support). If null, uses self.packages.\${system}.fennel";
        };
      };
    };
    default = { };
  };

  config = {
    perSystem =
      {
        lib,
        pkgs,
        self',
        system,
        ...
      }:
      let
        fennelPackage =
          if config.reovim.fennelPackage != null then
            config.reovim.fennelPackage
          else
            self'.packages.fennel;
        fs = lib.fileset;
        neovimPkgs = pkgs.extend inputs.neovim-nightly-overlay.overlays.default;

        lockfileLib = import ../lib/lockfile.nix {
          pkgs = neovimPkgs;
          inherit lib;
        };
        treesitterLib = import ../lib/treesitter.nix {
          pkgs = neovimPkgs;
          inherit lib;
        };

        neovimPackage = config.reovim.package neovimPkgs;

        rawConfigSource = fs.toSource {
          root = ./../..;
          fileset = configFiles;
        };

        # Pre-compile Fennel files at build time using external script
        configSource = pkgs.stdenv.mkDerivation {
          name = "reovim-config-with-compiled-lua";
          src = rawConfigSource;
          nativeBuildInputs = [
            neovimPkgs.neovim
            fennelPackage
          ];
          buildPhase = ''
            cp -r $src/. .
            chmod -R +w .

            export HOME=$TMPDIR
            # Enable nix build mode - `.nfnl.fnl` checks this to output to `lua/` instead of `data/nfnl/`
            export REOVIM_NIX_BUILD=1
            export NFNL_PATH="${neovimPkgs.vimPlugins.nfnl}"

            # Run the Fennel compilation script
            nvim --headless -u ${../lib/compile-fennel.lua} -c 'qall!'
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

            # Verify key bootstrap files exist
            for f in lua/bootstrap-nfnl.lua lua/fennel-loader.lua lua/rv-config/simple-plugins.lua; do
              if [ ! -f "$f" ]; then
                echo "✗ CRITICAL MISSING: $f"
                exit 1
              fi
            done
          '';
          installPhase = ''
            cp -r . $out
          '';
        };

        # Build treesitter grammars from lockfile
        treesitterGrammars = treesitterLib.mkTreesitterGrammarsFromLockfile {
          lockfilePath = config.reovim.lockfilePath;
        };

        # Create unified parser directory for all grammars
        parserDir = treesitterLib.mkParserDir {
          grammars = treesitterGrammars;
        };

        # Build regular plugins, excluding treesitter grammars
        lockfilePlugins =
          let
            grammarNames = map (g: g.name) treesitterGrammars;
            plugins = lockfileLib.mkPluginsFromLockfile {
              lockfilePath = config.reovim.lockfilePath;
              excludePlugins = grammarNames;
            };
          in
          lib.attrValues plugins;

        # Convert list of plugins to individual specs
        lockfilePluginSpecs = lib.listToAttrs (
          map (plugin: {
            name = plugin.pname or plugin.name or "unknown-plugin";
            value = {
              data = plugin;
              lazy = true;
            };
          }) lockfilePlugins
        );

        # Create spec for the parser plugin
        parserPlugin = pkgs.runCommand "treesitter-parser-plugin" { } ''
          mkdir -p $out
          ln -s ${parserDir}/parser $out/parser
          if [ -d "${parserDir}/queries" ]; then
            ln -s ${parserDir}/queries $out/queries
          fi
        '';

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
            config = {
              settings = {
                config_directory = "${configSource}";
                package = neovimPackage;
                viAlias = true;
                vimAlias = true;
                vimdiffAlias = true;
                infoPluginName = "nix-info-plugin-name";
              };
              specs = lockfilePluginSpecs // parserPluginSpec;
              extraPackages = [ fennelPackage ] ++ config.reovim.extraPackages;
              env.NVIM_APPNAME = "reovim";
              hosts = lib.genAttrs [ "python3" "node" "ruby" ] (lib.const { nvim-host.enable = false; });
            };
          }
        ];
      in
      {
        packages = {
          reovim = wrapperModule.config.wrap { inherit pkgs; };
          default = wrapperModule.config.wrap { inherit pkgs; };
        };
      };

    flake.overlays.reovim = final: prev: {
      reovim = inputs.self.packages.${final.stdenv.hostPlatform.system}.reovim;
    };
  };
}
