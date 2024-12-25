{ ... }:
{
  flake = {
    lib = {
      mkCode = import ./mkCode.nix;
    };
  };
}
