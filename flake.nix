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

    fennel-src = {
      url = "github:reo101/Fennel/feat/discard";
      flake = false;
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

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, lib, ... }:
      let
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
      in
      {
        systems = import inputs.systems.outPath;

        imports = [
          # Reovim-specific configuration
          ./nix/flake/reovim.nix
        ];

        perSystem =
          {
            lib,
            pkgs,
            self',
            ...
          }:
          {
            packages = {
              fennel = pkgs.callPackage ./nix/pkgs/fennel.nix {
                lua = pkgs.luajit;
                src = inputs.fennel-src;
              };
              luajitcoroutineclone = pkgs.callPackage ./nix/pkgs/luajitcoroutineclone/default.nix { };
            };

            devShells.default = pkgs.callPackage ./nix/shells/default/default.nix { };

            apps = {
              reovim = {
                type = "app";
                program = "${self'.packages.reovim}/bin/nvim";
              };
              default = self'.apps.reovim;
            };
            formatter = pkgs.nixfmt;
          };

        flake = {
          inherit configFiles;

          flakeModules.reovim =
            let
              configSource = fs.toSource {
                root = ./.;
                fileset = configFiles;
              };
            in
            inputs.nix-wrapper-modules.lib.evalModule {
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
      }
    );
}
