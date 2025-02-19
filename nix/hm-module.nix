{ nixpkgs, nix-vscode-extensions }:
{ self, ... }:
{
  flake.hmModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkOption
        mkEnableOption
        mkIf
        types
        ;

      finalPkgs = import nixpkgs {
        inherit (pkgs) system;
        config.allowUnfree = true;
      };

      cfg = config.modules.packages.nixcode;

      nixcodeType = import ./modules;
      nixcodeLib = self.lib.mkLib finalPkgs;
      ext = nix-vscode-extensions.extensions.${pkgs.system};
    in
    {
      options.modules.packages.nixcode = {
        enable = mkEnableOption "Enable nixcode";
        modules = mkOption {
          type = types.listOf (
            types.submoduleWith {
              description = "Nixcode build module";
              class = "nixcode";
              specialArgs = {
                inherit nixcodeLib ext;
                pkgs = finalPkgs;
              };
              modules = nixcodeType;
            }
          );
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
