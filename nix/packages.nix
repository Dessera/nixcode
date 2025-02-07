{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      nixcodeLib = self.lib.mkLib pkgs;
    in
    {
      packages.nixcode-nix = nixcodeLib.packages.mkNixcode {
        modules = [ self.nixcodeProfiles.nix ];
      };
    };
}
