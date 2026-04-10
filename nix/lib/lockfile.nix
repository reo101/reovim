{ pkgs, lib }:

let
  # Import custom plugin build configurations for Rust-based plugins
  pluginBuildsLib = import ./plugin-builds.nix { inherit pkgs lib; };

  matchUrlPatterns =
    patterns: url:
    lib.findFirst (match: match != null) null (
      builtins.map (pattern: builtins.match pattern url) patterns
    );

  ownerRepoFromMatch = match: {
    owner = builtins.elemAt match 0;
    repo = lib.removeSuffix ".git" (builtins.elemAt match 1);
  };

  buildPluginFromLockfileEntry =
    name: entry:
    let
      hash = entry.sha256 or "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      githubMatch = matchUrlPatterns [
        "https://github.com/([^/]+)/([^/]+)"
        "git@github.com:([^/]+)/([^/]+)"
      ] entry.src;
      sourcehutMatch = matchUrlPatterns [
        "https://git.sr.ht/~([^/]+)/([^/]+)"
        "git@git.sr.ht:~([^/]+)/([^/]+)"
      ] entry.src;
      src =
        if githubMatch != null then
          let
            githubParsed = ownerRepoFromMatch githubMatch;
          in
          pkgs.fetchFromGitHub {
            owner = githubParsed.owner;
            repo = githubParsed.repo;
            rev = entry.rev;
            inherit hash;
          }
        else if sourcehutMatch != null then
          let
            sourcehutParsed = ownerRepoFromMatch sourcehutMatch;
          in
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
      customBuildConfig =
        if hasCustomBuild then
          pluginBuildsLib.getBuildConfig name {
            inherit src hash;
            rev = entry.rev;
          }
        else
          null;
      useCustomBuild =
        hasCustomBuild
        && customBuildConfig != null
        && builtins.hasAttr "useCustomBuild" customBuildConfig
        && customBuildConfig.useCustomBuild;
    in
    if useCustomBuild then
      # Use the fully custom build (e.g., parinfer-rust with postInstall)
      customBuildConfig.src
    else if hasCustomBuild && customBuildConfig != null then
      # Use standard buildVimPlugin with custom overrides (e.g., blink.cmp, cornelis, bloat removal)
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
        // lib.optionalAttrs (builtins.hasAttr "postInstall" customBuildConfig) {
          postInstall = customBuildConfig.postInstall;
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

  mkPluginsFromLockfile =
    { lockfilePath, excludePlugins ? [ ] }:
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
      # Filter out explicitly excluded plugins (e.g., treesitter grammars handled separately)
      finalPlugins = lib.filterAttrs (name: _: !(builtins.elem name excludePlugins)) remotePlugins;
    in
    lib.mapAttrs buildPluginFromLockfileEntry finalPlugins;

in
{
  inherit mkPluginsFromLockfile;
}
