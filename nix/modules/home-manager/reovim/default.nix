{ inputs, outputs, ... }:
{ lib, pkgs, config, ... }:

let
  cfg = config.programs.reovim;
in
{
  imports =
    [
    ];

  options =
    {
      programs.reovim = {
        enable = lib.mkEnableOption "Reovim";
      };
    };

  config =
    lib.mkIf cfg.enable {
      nixpkgs = {
        overlays = [
          inputs.neovim-nightly-overlay.overlay
          inputs.rix101.overlays.additions
          inputs.cornelis.overlays.cornelis
        ];
      };

      programs.neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        plugins = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
          # pkgs.kakounePlugins.parinfer-rust
          cornelis
        ];
      };

      home.packages = with pkgs; [
        ## CLI dependencies
        ripgrep
        fd
        git
        ## LSPs and linters
        rust-analyzer
        rnix-lsp
        statix
        # fennel-language-server
        sumneko-lua-language-server
        stylua
        # nodePackages.vscode-langservers-extracted
        nodePackages.bash-language-server
        nodePackages.yaml-language-server
        nodePackages.typescript-language-server
        clang-tools
        # gopls
        ## Compiling native extensions
        # gcc
        gnumake
      ];
    };
}
