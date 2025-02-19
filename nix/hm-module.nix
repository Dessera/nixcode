{ self, ... }:
{
  flake.hmModule =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib)
        mkOption
        mkEnableOption
        mkIf
        types
        ;

      cfg = config.modules.packages.nixcode;

      nixcodeType = import ./modules;
      nixcodeLib = self.lib.mkLib pkgs;
    in
    {
      options.modules.packages.nixcode = {
        enable = mkEnableOption "Enable nixcode";
        modules = mkOption {
          type = types.listOf (types.submodule nixcodeType);
          default = [ ];
          description = "List of nixcode modules to enable";
        };
      };

      config = mkIf cfg.enable {
        home.packages = [
          (nixcodeLib.packages.mkNixcode {
            inherit (cfg) modules;
          })
        ];
      };
    };
}
