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
          if config.reovim.fennelPackage != null then config.reovim.fennelPackage else self'.packages.fennel;
        fs = lib.fileset;
        patchedNeovimOverlay =
          final: prev:
          let
            patchedNeovim = prev.neovim.override {
              luajit = self'.packages.luajitcoroutineclone;
            };
            patchedNeovimDebug = prev.neovim-debug.override {
              neovim = patchedNeovim;
            };
          in
          {
            neovim = patchedNeovim;
            neovim-unwrapped = patchedNeovim;
            neovim-debug = patchedNeovimDebug;
            neovim-developer = prev.neovim-developer.override {
              neovim-debug = patchedNeovimDebug;
              neovim-unwrapped = patchedNeovim;
            };
          };
        neovimPkgs = pkgs.extend (
          lib.composeManyExtensions [
            inputs.neovim-nightly-overlay.overlays.default
            patchedNeovimOverlay
          ]
        );

        lockfileLib = import ../lib/lockfile.nix {
          pkgs = neovimPkgs;
          inherit lib;
        };
        treesitterLib = import ../lib/treesitter.nix {
          pkgs = neovimPkgs;
          inherit lib;
        };
        allLockfilePlugins = lockfileLib.mkPluginsFromLockfile {
          lockfilePath = config.reovim.lockfilePath;
        };
        typedFennelBuildPlugin = allLockfilePlugins."typed-fennel";
        allTreesitterGrammars = treesitterLib.mkTreesitterGrammarsFromLockfile {
          lockfilePath = config.reovim.lockfilePath;
        };

        pluginGroups = {
          ai = [
            "amp.nvim"
            "blink-cmp-avante"
            "sidekick.nvim"
          ];
          writing = [
            "follow-md-links.nvim"
            "headlines.nvim"
            "markview.nvim"
            "mind.nvim"
            "nabla.nvim"
            "neorg"
            "neorg-telescope"
            "texmagic.nvim"
            "true-zen.nvim"
            "typst-preview.nvim"
            "typst.nvim"
          ];
          github = [
            "octo.nvim"
            "telescope-github.nvim"
          ];
          dap = [
            "nvim-dap"
            "nvim-dap-ui"
            "nvim-dap-virtual-text"
          ];
          testing = [
            "neotest"
            "neotest-busted"
            "neotest-foundry"
            "neotest-haskell"
            "neotest-zig"
          ];
          agda = [ "cornelis" ];
          native = [
            "fff.nvim"
            "parinfer-rust"
          ];
          treesitter_extra = [
            "tree-sitter-hy"
            "tree-sitter-jj_template"
            "tree-sitter-nu"
            "tree-sitter-uci"
          ];
        };

        grammarGroups = {
          writing = [
            "tree-sitter-norg_meta"
            "tree-sitter-norg_table"
          ];
          treesitter_extra = [
            "tree-sitter-awk"
            "tree-sitter-brainfuck"
            "tree-sitter-crisp"
            "tree-sitter-http"
            "tree-sitter-hy"
            "tree-sitter-jj_template"
            "tree-sitter-move"
            "tree-sitter-noir"
            "tree-sitter-nu"
            "tree-sitter-uci"
            "tree-sitter-xml"
          ];
        };

        profileCategoryFlags = rec {
          full = {
            ai = true;
            writing = true;
            github = true;
            dap = true;
            testing = true;
            agda = true;
            native = true;
            treesitter_extra = true;
          };
          dev = full // {
            writing = false;
          };
          lite = dev // {
            ai = false;
            github = false;
            dap = false;
            testing = false;
            agda = false;
            native = false;
            treesitter_extra = false;
          };
          writing = full // {
            ai = false;
            github = false;
            dap = false;
            testing = false;
            agda = false;
            native = false;
            treesitter_extra = false;
          };
        };

        categoryNames = lib.unique ((lib.attrNames pluginGroups) ++ (lib.attrNames grammarGroups));

        assertKnownCategories =
          names:
          let
            unknown = lib.filter (name: !(builtins.elem name categoryNames)) names;
          in
          if unknown != [ ] then
            throw "Unknown reovim categories: ${lib.concatStringsSep ", " unknown}"
          else
            names;

        categoryFlagsFromNames =
          names:
          let
            enabledNames = assertKnownCategories names;
          in
          lib.genAttrs categoryNames (name: builtins.elem name enabledNames);

        resolveProfileInput =
          argsOrProfile:
          if builtins.isString argsOrProfile then
            {
              profileLabel = argsOrProfile;
              enabledCategoryFlags =
                profileCategoryFlags.${argsOrProfile}
                or (throw "Unknown reovim profile: ${argsOrProfile}");
            }
          else if builtins.isList argsOrProfile then
            {
              profileLabel = "custom";
              enabledCategoryFlags = categoryFlagsFromNames argsOrProfile;
            }
          else
            let
              hasProfile = argsOrProfile ? profile;
              hasCategories = argsOrProfile ? categories;
              _ =
                if hasProfile && hasCategories then
                  throw "Use either `profile` or `categories`, not both"
                else
                  null;
              baseCategoryFlags =
                if hasCategories then
                  categoryFlagsFromNames argsOrProfile.categories
                else if hasProfile then
                  profileCategoryFlags.${argsOrProfile.profile}
                  or (throw "Unknown reovim profile: ${argsOrProfile.profile}")
                else
                  categoryFlagsFromNames [ ];
              enabledCategories = assertKnownCategories (argsOrProfile.enable or [ ]);
              disabledCategories = assertKnownCategories (argsOrProfile.disable or [ ]);
              enabledCategoryFlags = lib.mapAttrs
                (name: enabled:
                  if builtins.elem name enabledCategories then
                    true
                  else if builtins.elem name disabledCategories then
                    false
                  else
                    enabled)
                baseCategoryFlags;
            in
            {
              profileLabel =
                if hasCategories then
                  "custom"
                else
                  (argsOrProfile.profile or "custom");
              inherit enabledCategoryFlags;
            };

        disabledMembers =
          groups: enabledCategoryFlags:
          lib.unique (
            lib.flatten (
              lib.mapAttrsToList (
                group: members: lib.optionals (!(enabledCategoryFlags.${group} or false)) members
              ) groups
            )
          );

        neovimPackage = config.reovim.package neovimPkgs;

        rawConfigSource = fs.toSource {
          root = ./../..;
          fileset = configFiles;
        };

        configSource = pkgs.stdenv.mkDerivation {
          name = "reovim-config-with-compiled-lua";
          src = rawConfigSource;
          nativeBuildInputs = [
            neovimPackage
            fennelPackage
          ];
          buildPhase = ''
            cp -r $src/. .
            chmod -R +w .

            export HOME=$TMPDIR
            # Enable nix build mode - `.nfnl.fnl` checks this to output to `lua/` instead of `data/nfnl/`
            export REOVIM_NIX_BUILD=1
            export NFNL_PATH="${neovimPkgs.vimPlugins.nfnl}"
            export REOVIM_BUILD_PACKPATH="$TMPDIR/reovim-pack"
            mkdir -p "$REOVIM_BUILD_PACKPATH/pack/reovim/opt"
            ln -s ${typedFennelBuildPlugin} "$REOVIM_BUILD_PACKPATH/pack/reovim/opt/typed-fennel"

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

        mkWrappedPackage =
          argsOrProfile:
          let
            resolved = resolveProfileInput argsOrProfile;
            profileLabel = resolved.profileLabel;
            enabledCategoryFlags = resolved.enabledCategoryFlags;
            excludedPlugins = disabledMembers pluginGroups enabledCategoryFlags;
            excludedGrammars = disabledMembers grammarGroups enabledCategoryFlags;
            selectedLockfilePlugins = lib.filterAttrs
              (name: _: !(builtins.elem name excludedPlugins))
              allLockfilePlugins;
            typedFennelBuildPlugin = selectedLockfilePlugins."typed-fennel";
            treesitterGrammars = lib.filter
              (grammar: !(builtins.elem grammar.name excludedGrammars))
              allTreesitterGrammars;
            parserDir = treesitterLib.mkParserDir {
              grammars = treesitterGrammars;
            };
            lockfilePlugins =
              let
                grammarNames = map (g: g.name) treesitterGrammars;
                plugins = lib.filterAttrs (name: _: !(builtins.elem name grammarNames)) selectedLockfilePlugins;
              in
              lib.attrValues plugins;
            lockfilePluginSpecs = lib.listToAttrs (
              map (plugin: {
                name = plugin.pname or plugin.name or "unknown-plugin";
                value = {
                  data = plugin;
                  lazy = true;
                };
              }) lockfilePlugins
            );
            parserPlugin = pkgs.runCommand "treesitter-parser-plugin-${profileLabel}" { } ''
              mkdir -p $out
              ln -s ${parserDir}/parser $out/parser
              if [ -d "${parserDir}/queries" ]; then
                ln -s ${parserDir}/queries $out/queries
              fi
            '';
            parserPluginSpec = lib.optionalAttrs (treesitterGrammars != [ ]) {
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
                  package = neovimPackage;
                  settings = {
                    config_directory = "${configSource}";
                    viAlias = true;
                    vimAlias = true;
                    vimdiffAlias = true;
                    infoPluginName = "nix-info-plugin-name";
                    profile = profileLabel;
                  };
                  specs = lockfilePluginSpecs // parserPluginSpec;
                  extraPackages = [ fennelPackage ] ++ config.reovim.extraPackages;
                  env.NVIM_APPNAME = "reovim";
                  hosts = lib.genAttrs [ "python3" "node" "ruby" ] (lib.const { nvim-host.enable = false; });
                };
              }
            ];
          in
          wrapperModule.config.wrap { pkgs = neovimPkgs; };

        devPackage = mkWrappedPackage "dev";
        fullPackage = mkWrappedPackage "full";
        litePackage = mkWrappedPackage "lite";
        writingPackage = mkWrappedPackage "writing";
        packageWithProfile =
          argsOrProfile:
          mkWrappedPackage argsOrProfile;
        availableProfiles = builtins.attrNames profileCategoryFlags;
        profileMetadata = {
          inherit availableProfiles categoryNames profileCategoryFlags pluginGroups grammarGroups;
          availableCategories = categoryNames;
        };
        reovimPackage =
          devPackage
          // {
            dev = devPackage;
            full = fullPackage;
            lite = litePackage;
            writing = writingPackage;
            inherit (profileMetadata) availableProfiles availableCategories categoryNames profileCategoryFlags pluginGroups grammarGroups;
            withProfile = packageWithProfile;
            overrideProfile = packageWithProfile;
            passthru = (devPackage.passthru or { }) // profileMetadata // {
              dev = devPackage;
              full = fullPackage;
              lite = litePackage;
              writing = writingPackage;
              withProfile = packageWithProfile;
              overrideProfile = packageWithProfile;
            };
          };
      in
      {
        packages = {
          reovim = reovimPackage;
          default = reovimPackage;
          dev = devPackage;
          full = fullPackage;
          lite = litePackage;
          writing = writingPackage;
        };
      };

    flake.overlays.reovim = final: prev: {
      reovim = inputs.self.packages.${final.stdenv.hostPlatform.system}.reovim;
    };
  };
}
