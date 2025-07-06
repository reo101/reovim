{ mkShell
, pkgs
, ...
}:

mkShell {
  name = "reovim-dev";

  buildInputs = with pkgs; [
    # Nix tools
    nixfmt
    nix-prefetch-git

    # Lua/Fennel tools
    lua-language-server
    stylua

    # Git tools
    git
    jj
  ];

  shellHook = ''
    echo "Welcome to reovim development shell!"
    echo "Run 'nix run .#reovim' to test the config"
    echo "Run 'nix fmt' to format Nix files"
  '';
}
