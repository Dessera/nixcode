{ nixpkgs }:
{ self, ... }:
{
  flake = {
    lib = {
      mkCode = import ./mkCode.nix self.lib;
      mkUserData = import ./mkUserData.nix nixpkgs.lib;
      mkDerive = import ./mkDerive.nix nixpkgs.lib;
    };
  };
}
