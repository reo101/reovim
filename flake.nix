{
  description = "reo101's Neovim configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    systems = {
      url = "github:nix-systems/default";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    rix101 = {
      url = "github:reo101/rix101";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-lib-net = {
      url = "github:reo101/nix-lib-net";
    };

    cornelis = {
      url = "github:isovector/cornelis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, lib, ... }: let
    fs = lib.fileset;
    # Define the config files once, reused in both flakeModules and perSystem
    configFiles = fs.unions [
      ./.nfnl.fnl
      ./init.fnl
      ./init.lua
      ./fnl
      ./lua
      ./after
      ./syntax
      ./lsp
      ./luasnippets
    ];
  in {
      systems = import inputs.systems.outPath;

      imports = [
        # Use rix101's auto-things modules
        # Use lib-custom which extends lib with kebabToCamel and other helpers
        inputs.rix101.modules.flake.lib-custom
        inputs.rix101.modules.flake.things
        inputs.rix101.modules.flake.packages
        inputs.rix101.modules.flake.overlays
        inputs.rix101.modules.flake.shells
        inputs.rix101.modules.flake.modules
        # Reovim-specific configuration
        ./nix/flake/reovim.nix
      ];

      auto = {
        # Configure auto-things from rix101
        packages = {
          enable = true;
          dir = ./nix/pkgs;
        };
        overlays = {
          enable = true;
          dir = ./nix/overlays;
        };
        devShells = {
          enable = true;
          dir = ./nix/shells;
        };
      };

      perSystem = { lib, pkgs, system, ... }: {
        apps = {
          reovim = {
            type = "app";
            program = "${inputs.self.packages.${system}.reovim}/bin/nvim";
          };
          default = inputs.self.apps.${system}.reovim;
        };
        formatter = pkgs.nixfmt;
      };

      flake = {
        inherit configFiles;

        flakeModules.reovim = let
          configSource = fs.toSource {
            root = ./.;
            fileset = configFiles;
          };
        in inputs.nix-wrapper-modules.lib.evalModule {
          imports = [ inputs.nix-wrapper-modules.lib.wrapperModules.neovim ];
          # Convert the source to a string path for Lua concatenation
          config.settings.config_directory = "${configSource}";
        };

        nixosModules = {
          default = inputs.self.nixosModules.reovim;
          reovim = inputs.nix-wrapper-modules.lib.mkInstallModule {
            name = "reovim";
            value = inputs.self.flakeModules.reovim;
          };
        };
      };
    });
}
