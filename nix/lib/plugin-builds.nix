# Custom build configurations for specific plugins requiring special handling
# Plugins like parinfer-rust and blink.cmp need Rust compilation

{ pkgs, lib }:

let
  inherit (pkgs) stdenv;

  # Get the appropriate shared library extension for the platform
  sharedLibExt = stdenv.hostPlatform.extensions.sharedLibrary;

  # Plugin-specific build configurations
  # Each receives the entry attrset with { src, hash, rev, ... }
  pluginBuilds = {
    # parinfer-rust: Needs cargo build --release to compile the Rust binary
    parinfer-rust = entry:
      let
        inherit (entry) src;
        # Build the Rust binary using buildRustPackage
        parinfer-binary = pkgs.rustPlatform.buildRustPackage {
          pname = "parinfer-rust";
          version = builtins.substring 0 7 entry.rev;
          inherit src;

          cargoHash = "sha256-sgqzAFZmfpacyjDOvJNyj3IwQGTTKcxV9bHzNCSm6Ig=";

          nativeBuildInputs = with pkgs; [
            llvmPackages.clang
          ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
            libiconv
          ];

          buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
            pkgs.libiconv
          ];

          # Disable tests as they may fail in sandbox
          doCheck = false;

          postInstall = ''
            # Create the vim plugin directory structure
            mkdir -p $out/plugin

            # Patch the vim plugin to use our binary path
            sed "s,let s:libdir = .*,let s:libdir = '${placeholder "out"}/lib'," \
              $src/plugin/parinfer.vim > $out/plugin/parinfer.vim

            # Copy doc files
            if [ -d $src/doc ]; then
              mkdir -p $out/doc
              cp -r $src/doc/* $out/doc/
            fi
          '';
        };
      in
      {
        # Return the pre-built derivation directly
        # parinfer-rust's postInstall already creates the vim plugin structure
        src = parinfer-binary;
        # Skip the standard buildVimPlugin since we have custom postInstall
        useCustomBuild = true;
      };

    # blink.cmp: Needs Rust compilation for the fuzzy matcher library
    blink.cmp = entry:
      let
        inherit (entry) src;
        # Build the Rust fuzzy library separately
        blink-fuzzy-lib = pkgs.rustPlatform.buildRustPackage {
          pname = "blink-fuzzy-lib";
          version = builtins.substring 0 7 entry.rev;
          inherit src;

          cargoHash = "sha256-Qdt8O7IGj2HySb1jxsv3m33ZxJg96Ckw26oTEEyQjfs=";

          nativeBuildInputs = with pkgs; [
            gitMinimal
          ];

          env = {
            RUSTC_BOOTSTRAP = true;
            # Darwin needs special linking flags for LuaJIT compatibility
            RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin
              "-C link-arg=-undefined -C link-arg=dynamic_lookup";
          };

          # Disable tests in the build
          doCheck = false;
        };
      in
      {
        inherit src;
        # Pre-install hook to link the compiled library
        preInstall = ''
          mkdir -p target/release
          ln -s ${blink-fuzzy-lib}/lib/libblink_cmp_fuzzy${sharedLibExt} target/release/libblink_cmp_fuzzy${sharedLibExt}
        '';
        # Additional passthru for debugging
        passthru = {
          inherit blink-fuzzy-lib;
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
