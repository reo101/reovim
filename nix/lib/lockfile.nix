{ pkgs, lib }:

let
  # Import custom plugin build configurations for Rust-based plugins
  pluginBuildsLib = import ./plugin-builds.nix { inherit pkgs lib; };

  parseGitHubUrl =
    url:
    let
      patterns = [
        "https://github.com/([^/]+)/([^/]+)"
        "git@github.com:([^/]+)/([^/]+)"
      ];
      matches = lib.map (lib.flip builtins.match url) patterns;
    in
    lib.mapNullable (m: {
      owner = builtins.elemAt m 0;
      repo = lib.removeSuffix ".git" (builtins.elemAt m 1);
    }) (lib.findFirst (m: m != null) null matches);

  parseSourcehutUrl =
    url:
    let
      patterns = [
        "https://git.sr.ht/~([^/]+)/([^/]+)"
        "git@git.sr.ht:~([^/]+)/([^/]+)"
      ];
      matches = lib.map (lib.flip builtins.match url) patterns;
    in
    lib.mapNullable (m: {
      owner = builtins.elemAt m 0;
      repo = lib.removeSuffix ".git" (builtins.elemAt m 1);
    }) (lib.findFirst (m: m != null) null matches);

  buildPluginFromLockfileEntry =
    name: entry:
    let
      githubParsed = parseGitHubUrl entry.src;
      sourcehutParsed = parseSourcehutUrl entry.src;
      hash = entry.sha256 or "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      src =
        if githubParsed != null then
          pkgs.fetchFromGitHub {
            owner = githubParsed.owner;
            repo = githubParsed.repo;
            rev = entry.rev;
            inherit hash;
          }
        else if sourcehutParsed != null then
          pkgs.fetchFromSourcehut {
            owner = sourcehutParsed.owner;
            repo = sourcehutParsed.repo;
            rev = entry.rev;
            inherit hash;
          }
        else
          pkgs.fetchgit {
            url = entry.src;
            rev = entry.rev;
            inherit hash;
          };
      # Plugin-specific nvimSkipModules to skip failing require checks
      skipModules = (import ./skip-modules.nix).${name} or [ ];
      # Check for custom build configuration (e.g., for Rust-based plugins)
      hasCustomBuild = pluginBuildsLib.hasCustomBuild name;
      customBuildConfig = if hasCustomBuild
        then pluginBuildsLib.getBuildConfig name { inherit src hash; rev = entry.rev; }
        else null;
      useCustomBuild = hasCustomBuild && customBuildConfig != null && builtins.hasAttr "useCustomBuild" customBuildConfig && customBuildConfig.useCustomBuild;
    in
    if useCustomBuild then
      # Use the fully custom build (e.g., parinfer-rust with postInstall)
      customBuildConfig.src
    else if hasCustomBuild && customBuildConfig != null then
      # Use standard buildVimPlugin with custom overrides (e.g., blink.cmp with preInstall)
      pkgs.vimUtils.buildVimPlugin (
        {
          pname = name;
          version = entry.rev;
          inherit src;
        }
        // lib.optionalAttrs (skipModules != [ ]) {
          nvimSkipModules = skipModules;
        }
        // lib.optionalAttrs (builtins.hasAttr "preInstall" customBuildConfig) {
          preInstall = customBuildConfig.preInstall;
        }
        // lib.optionalAttrs (builtins.hasAttr "passthru" customBuildConfig) {
          passthru = customBuildConfig.passthru;
        }
      )
    else
      # Standard build with no custom configuration
      pkgs.vimUtils.buildVimPlugin (
        {
          pname = name;
          version = entry.rev;
          inherit src;
        }
        // lib.optionalAttrs (skipModules != [ ]) {
          nvimSkipModules = skipModules;
        }
      );

  # Check if a plugin has a problematic IFD by checking platform-specific builds
  # Returns true if the plugin can be safely built on this platform
  canBuildSafely =
    name: entry:
    let
      # Cornelis has IFD issues - only build on Darwin where cabal2nix works
      isCornelis = name == "cornelis" || lib.hasPrefix "cornelis" name;
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    in
    isCornelis -> isDarwin;

  mkPluginsFromLockfile =
    { lockfilePath, excludePlugins ? [] }:
    let
      lockfile = lib.importJSON lockfilePath;
      # Filter out local paths (starting with / or ./ or ../)
      isRemote =
        name: entry:
        let
          src = entry.src or "";
        in
        !(lib.hasPrefix "/" src || lib.hasPrefix "./" src || lib.hasPrefix "../" src);
      remotePlugins = lib.filterAttrs isRemote lockfile.plugins;
      # Filter out plugins that can't be built on this platform (IFD issues)
      safePlugins = lib.filterAttrs canBuildSafely remotePlugins;
      # Filter out explicitly excluded plugins (e.g., treesitter grammars handled separately)
      finalPlugins = lib.filterAttrs (name: _: !(builtins.elem name excludePlugins)) safePlugins;
    in
    lib.mapAttrs buildPluginFromLockfileEntry finalPlugins;

  # Get names of plugins that were skipped due to platform issues
  getSkippedPlugins =
    lockfilePath:
    let
      lockfile = lib.importJSON lockfilePath;
      isRemote =
        name: entry:
        let
          src = entry.src or "";
        in
        !(lib.hasPrefix "/" src || lib.hasPrefix "./" src || lib.hasPrefix "../" src);
      remotePlugins = lib.filterAttrs isRemote lockfile.plugins;
      unsafePlugins = lib.filterAttrs (name: entry: !canBuildSafely name entry) remotePlugins;
    in
    builtins.attrNames unsafePlugins;

in
{
  inherit mkPluginsFromLockfile parseGitHubUrl parseSourcehutUrl getSkippedPlugins;
}
