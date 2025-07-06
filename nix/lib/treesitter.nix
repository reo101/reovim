# TreeSitter grammar builder for lockfile-based parsers
# Handles custom treesitter grammars from nvim-pack-lock.json

{ pkgs, lib }:

let
  inherit (pkgs) stdenv tree-sitter neovimUtils;

  # Parse GitHub URL to extract owner/repo
  parseGitHubUrl = url:
    let
      httpsMatch = builtins.match "https://github.com/([^/]+)/([^/]+)" url;
      sshMatch = builtins.match "git@github.com:([^/]+)/([^/]+)" url;
      match = if httpsMatch != null then httpsMatch else sshMatch;
    in
    if match != null then {
      owner = builtins.elemAt match 0;
      repo = lib.removeSuffix ".git" (builtins.elemAt match 1);
    } else null;

  # Build a single treesitter grammar from lockfile entry
  # Returns { name = <entry-name>; lang = <tree_sitter_lang>; drv = <derivation>; }
  buildGrammarFromLockfile = name: entry:
    let
      language = lib.removePrefix "tree-sitter-" name;
      grammarName = lib.replaceStrings ["-"] ["_"] language;

      githubParsed = parseGitHubUrl entry.src;
      hash = entry.sha256 or "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

      src =
        if githubParsed != null then
          pkgs.fetchFromGitHub {
            owner = githubParsed.owner;
            repo = githubParsed.repo;
            rev = entry.rev;
            inherit hash;
          }
        else
          pkgs.fetchgit {
            url = entry.src;
            rev = entry.rev;
            inherit hash;
          };

      drv = tree-sitter.buildGrammar {
        language = grammarName;
        version = builtins.substring 0 7 entry.rev;
        inherit src;

        # Auto-detect if we need to generate (no parser.c means we need tree-sitter generate)
        generate = lib.optionalString
          (!(builtins.pathExists "${src}/src/parser.c"))
          "true";

        nativeBuildInputs = [
          pkgs.nodejs
          pkgs.tree-sitter
          pkgs.jq
        ];

        preBuild = ''
          if [ -f package.json ] && [ ! -d node_modules ]; then
            if grep -q "tree-sitter" package.json 2>/dev/null; then
              npm install 2>/dev/null || true
            fi
          fi
        '';
      };
    in
    {
      inherit name drv;
      lang = "tree_sitter_${grammarName}";
    };

  # Check if an entry is a treesitter grammar
  isTreesitterGrammar = name: entry:
    lib.hasPrefix "tree-sitter-" name;

  # Build all treesitter grammars from lockfile
  # Grammars are stored under a "grammars" key in nvim-pack-lock.json
  # Returns list of { name = <name>; lang = <tree_sitter_lang>; drv = <derivation>; }
  mkTreesitterGrammarsFromLockfile = { lockfilePath }:
    let
      lockfile = lib.importJSON lockfilePath;
      # Get grammars from the dedicated "grammars" section (if it exists)
      grammarEntries = lockfile.grammars or {};
      # Also check legacy location in plugins (for backwards compatibility)
      pluginGrammarEntries = lib.filterAttrs isTreesitterGrammar (lockfile.plugins or {});
      # Merge: dedicated grammars section takes precedence
      allGrammarEntries = pluginGrammarEntries // grammarEntries;
      # Build all grammars - returns list of attrsets
      grammarList = lib.mapAttrsToList buildGrammarFromLockfile allGrammarEntries;
    in
    grammarList;

  # Get the appropriate shared library extension for the platform
  inherit (stdenv.hostPlatform.extensions) sharedLibrary;

  # Create a unified parser directory with all grammars using linkFarm
  # We use runCommand with shell script to avoid IFD from builtins.pathExists
  # grammars is a list of { name = <name>; lang = <tree_sitter_lang>; drv = <derivation>; }
  mkParserDir = { grammars }:
    pkgs.runCommand "treesitter-parsers" {} ''
      mkdir -p $out/parser
      mkdir -p $out/queries

      ${lib.concatStrings (map (grammarInfo: ''
        # Link parser for ${grammarInfo.name}
        ln -s ${grammarInfo.drv}/lib/${grammarInfo.lang}/parser/${grammarInfo.lang}${sharedLibrary} $out/parser/

        # Link queries if they exist (using shell test, not IFD)
        if [ -d "${grammarInfo.drv}/lib/${grammarInfo.lang}/queries/${grammarInfo.lang}" ]; then
          mkdir -p $out/queries/${grammarInfo.lang}
          for query in ${grammarInfo.drv}/lib/${grammarInfo.lang}/queries/${grammarInfo.lang}/*; do
            if [ -f "$query" ]; then
              ln -s "$query" $out/queries/${grammarInfo.lang}/
            fi
          done
        fi
      '') grammars)}
    '';

in
{
  inherit
    mkTreesitterGrammarsFromLockfile
    mkParserDir
    isTreesitterGrammar
    buildGrammarFromLockfile
    parseGitHubUrl;
}
