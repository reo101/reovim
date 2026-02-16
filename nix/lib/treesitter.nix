# TreeSitter grammar builder for lockfile-based parsers
# Handles custom treesitter grammars from nvim-pack-lock.json

{ pkgs, lib }:

let
  inherit (pkgs) stdenv tree-sitter;

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
  # Returns { name = <entry-name>; lang = <language_name>; drv = <derivation>; }
  buildGrammarFromLockfile = name: entry:
    let
      language = lib.removePrefix "tree-sitter-" name;
      # Neovim expects parser/<language>.so where language uses underscores
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

      # Determine if we need tree-sitter generate:
      # - If the lockfile entry has no "files" field, it needs generate
      # - If files is empty, it needs generate
      # - If files doesn't include "src/parser.c", it needs generate
      # This avoids IFD (builtins.pathExists on a derivation path)
      files = entry.files or [];
      needsGenerate = files == [] || !(builtins.elem "src/parser.c" files);

      drv = tree-sitter.buildGrammar {
        language = grammarName;
        version = builtins.substring 0 7 entry.rev;
        inherit src;
        generate = needsGenerate;
      };
    in
    {
      inherit name drv;
      lang = grammarName;
    };

  # Check if an entry is a treesitter grammar
  isTreesitterGrammar = name: entry:
    lib.hasPrefix "tree-sitter-" name;

  # Build all treesitter grammars from lockfile
  # Grammars are stored under a "grammars" key in nvim-pack-lock.json
  # Returns list of { name = <name>; lang = <language_name>; drv = <derivation>; }
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

  # Create a unified parser directory with all grammars
  # buildGrammar outputs: $out/parser (the .so binary), $out/queries/*.scm (optional)
  # Neovim expects: parser/<lang>.so and queries/<lang>/*.scm in rtp
  # grammars is a list of { name = <name>; lang = <language_name>; drv = <derivation>; }
  mkParserDir = { grammars }:
    pkgs.runCommand "treesitter-parsers" {} ''
      mkdir -p $out/parser
      mkdir -p $out/queries

      ${lib.concatStrings (map (grammarInfo: ''
        # Link parser for ${grammarInfo.name}
        ln -s ${grammarInfo.drv}/parser $out/parser/${grammarInfo.lang}${sharedLibrary}

        # Link queries if they exist
        # buildGrammar puts queries directly in $out/queries/ (no lang subdirectory)
        # but Neovim expects them in queries/<lang>/
        if [ -d "${grammarInfo.drv}/queries" ]; then
          mkdir -p $out/queries/${grammarInfo.lang}
          for query in ${grammarInfo.drv}/queries/*; do
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
