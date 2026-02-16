{ lib }:

{
  # Parse GitHub URL to extract owner/repo
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

  # Parse Sourcehut URL to extract owner/repo
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
}
