{
  description = "reo101's Neovim configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rix101 = {
      url = "github:reo101/rix101";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cornelis = {
      url = "github:isovector/cornelis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://rix101.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "rix101.cachix.org-1:2u9ZGi93zY3hJXQyoHkNBZpJK+GiXQyYf9J5TLzCpFY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    { self
    , nixpkgs
    , neovim-nightly-overlay
    , rix101
    , cornelis
    , ...
    } @ inputs :
    let
      inherit (self) outputs;
      util = import ./nix/util.nix {
        inherit inputs outputs;
      };
    in
    rec {
      # Packages (`nix build`)
      packages = util.forEachPkgs (pkgs:
        import ./nix/pkgs { inherit pkgs; }
      );

      # Apps (`nix run`)
      apps = util.forEachPkgs (pkgs:
        import ./nix/apps { inherit pkgs; }
      );

      # Home Manager modules
      homeManagerModules = import ./nix/modules/home-manager {
        inherit inputs outputs;
      };
    };
}
