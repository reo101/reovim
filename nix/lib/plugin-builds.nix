# Custom build configurations for specific plugins requiring special handling
# Plugins like parinfer-rust, blink.cmp, and cornelis need native compilation
# Also handles stripping bloat (tests, assets, wiki, etc.) from plugin sources

{ pkgs, lib }:

let
  inherit (pkgs) stdenv;

  # Get the appropriate shared library extension for the platform
  sharedLibExt = stdenv.hostPlatform.extensions.sharedLibrary;

  # Build a script (for `postInstall`) that removes the given paths from `$target`
  rmPaths = paths: lib.concatMapStringsSep "\n" (p: "rm -rf $target/${lib.escapeShellArg p}") paths;

  # Bloat removal: paths to strip from plugin derivations
  pluginBloatPaths = {
    "snacks.nvim" = [ "tests" ];
    "markview.nvim" = [
      "markview.nvim.wiki"
      "test"
    ];
    "tabout.nvim" = [ "assets" ];
    "BQN" = [
      "docs"
      "fonts"
      "implementation"
    ];
    "conjure" = [
      "dev"
      "docs"
    ];
    "harpoon" = [ "scripts" ];
    "nvim-treesitter" = [
      "parser"
      "parser-info"
      "tests"
    ];
  };

  # Plugin-specific build configurations
  # Each receives the entry attrset with `{ src, hash, rev, ... }`
  pluginBuilds =
    lib.mapAttrs (_: paths: entry: {
      inherit (entry) src;
      postInstall = rmPaths paths;
    }) pluginBloatPaths
    // {
      # -- Native builds ------------------------------------------------------
      # parinfer-rust: Needs cargo build `--release` to compile the Rust binary
      parinfer-rust =
        entry:
        let
          inherit (entry) src;
          # Build the Rust binary using buildRustPackage
          parinfer-binary = pkgs.rustPlatform.buildRustPackage {
            pname = "parinfer-rust";
            version = builtins.substring 0 7 entry.rev;
            inherit src;

            cargoHash = "sha256-sgqzAFZmfpacyjDOvJNyj3IwQGTTKcxV9bHzNCSm6Ig=";

            nativeBuildInputs =
              [
                pkgs.llvmPackages.clang
              ]
              ++ lib.optionals stdenv.hostPlatform.isDarwin [
                pkgs.libiconv
              ];

            buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
              pkgs.libiconv
            ];

            # Disable tests as they may fail in sandbox
            doCheck = false;

            postInstall = lib.concatStringsSep "\n" [
              # Create the vim plugin directory structure
              # bash
              ''
                mkdir -p $out/plugin
              ''
              # Patch the vim plugin to use our binary path
              # bash
              ''
                sed "s,let s:libdir = .*,let s:libdir = '${placeholder "out"}/lib'," \
                  $src/plugin/parinfer.vim > $out/plugin/parinfer.vim
              ''
              # Copy doc files
              # bash
              ''
                if [ -d $src/doc ]; then
                  mkdir -p $out/doc
                  cp -r $src/doc/* $out/doc/
                fi
              ''
            ];
          };
        in
        {
          # Return the pre-built derivation directly
          # `parinfer-rust`'s `postInstall` already creates the vim plugin structure
          src = parinfer-binary;
          # Skip the standard `buildVimPlugin` since we have custom `postInstall`
          useCustomBuild = true;
        };

      # blink.cmp: Needs Rust compilation for the fuzzy matcher library
      "blink.cmp" =
        entry:
        let
          inherit (entry) src;
          # Build the Rust fuzzy library separately
          blink-fuzzy-lib = pkgs.rustPlatform.buildRustPackage {
            pname = "blink-fuzzy-lib";
            version = builtins.substring 0 7 entry.rev;
            inherit src;

            cargoHash = "sha256-Qdt8O7IGj2HySb1jxsv3m33ZxJg96Ckw26oTEEyQjfs=";

            # Pin frizbee to 0.6.0 to avoid nightly-only std::simd in 0.7.0
            cargoPatches = [
              ./blink-cmp-pin-frizbee-0.6.0.patch
            ];

            nativeBuildInputs = with pkgs; [
              gitMinimal
            ];

            env = {
              RUSTC_BOOTSTRAP = true;
              # Darwin needs special linking flags for LuaJIT compatibility
              RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";
            };

            # Disable tests in the build
            doCheck = false;
          };
        in
        {
          inherit src;
          # Pre-install hook to link the compiled library into the build directory
          # `blink.cmp` looks for the library at: `plugin_root/target/release/libblink_cmp_fuzzy.{so,dylib}`
          # `preInstall` runs before `cp -r . $target`, so `target/` gets copied into the output
          preInstall = ''
            mkdir -p target/release
            ln -s ${blink-fuzzy-lib}/lib/libblink_cmp_fuzzy${sharedLibExt} target/release/libblink_cmp_fuzzy${sharedLibExt}
          '';
          # Additional passthru for debugging
          passthru = {
            inherit blink-fuzzy-lib;
          };
        };
      # cornelis: Haskell-based Agda mode – needs a pre-built binary so nvim-hs
      # doesn't try to compile it at runtime via stack/cabal.
      cornelis =
        entry:
        let
          inherit (entry) src;
          # Use the cornelis binary already packaged in nixpkgs
          cornelis-bin = pkgs.cornelis;
        in
        {
          inherit src;
          # Patch ftplugin/agda.vim so cornelis always uses the Nix-built binary
          # instead of trying to compile via nvimhs#start (stack/cabal at runtime).
          # Replace the entire if/else/endif block with a direct rpcstart call.
          preInstall = ''
            sed -i '/if exists("g:cornelis_use_global_binary")/,/endif/{
              /if exists/c\call remote#host#Register('"'"'cornelis'"'"', '"'"'*'"'"', rpcstart('"'"'${cornelis-bin}/bin/cornelis'"'"', []))
              /else/,/endif/d
            }' ftplugin/agda.vim
            # Remove the F5 compile-and-restart mapping (useless with a pre-built binary)
            sed -i '/nvimhs#compileAndRestart/d' ftplugin/agda.vim
          '';
          # Strip build artefacts that are useless at runtime
          postInstall = rmPaths [
            "src"
            "app"
            "test"
            ".github"
            ".stack-work"
            "cast.gif"
            "stack.yaml"
            "stack.yaml.lock"
            "cornelis.cabal"
            "package.yaml"
            "Setup.hs"
            "default.nix"
            "flake.nix"
            "flake.lock"
            ".hlint.yaml"
            ".gitignore"
          ];
          passthru = {
            inherit cornelis-bin;
          };
        };
    };
in
{
  # Check if a plugin has a custom build configuration
  hasCustomBuild = name: builtins.hasAttr name pluginBuilds;

  # Get custom build configuration for a plugin
  getBuildConfig = name: entry: pluginBuilds.${name} entry;

  # Expose pluginBuilds for potential external access
  inherit pluginBuilds;
}
