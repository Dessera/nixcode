{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      nixcodeLib = self.lib.mkLib pkgs;
    in
    {
      packages = {
        nixcode-cpp = nixcodeLib.packages.mkNixcode {
          modules = [ self.nixcodeProfiles.cpp ];
        };

        nixcode-jvm = nixcodeLib.packages.mkNixcode {
          modules = [ self.nixcodeProfiles.jvm ];
        };

        nixcode-nix = nixcodeLib.packages.mkNixcode {
          modules = [ self.nixcodeProfiles.nix ];
        };

        nixcode-python = nixcodeLib.packages.mkNixcode {
          modules = [ self.nixcodeProfiles.python ];
        };

        nixcode-rust = nixcodeLib.packages.mkNixcode {
          modules = [ self.nixcodeProfiles.rust ];
        };

        nixcode-web = nixcodeLib.packages.mkNixcode {
          modules = [ self.nixcodeProfiles.web ];
        };
      };
    };
}
