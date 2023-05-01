{ inputs, outputs, ... }:
{
  # my-module = import ./my-module.nix;
  reovim = import ./reovim { inherit inputs outputs; };
}
