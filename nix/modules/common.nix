{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.identifier = mkOption {
    type = types.str;
    default = "default";
    description = "The identifier for the nixcode package";
  };

  options.pname = mkOption {
    type = types.str;
    default = "nixcode";
    description = "The name of the package";
  };

  options.package = mkOption {
    type = types.package;
    default = pkgs.vscode;
    description = "The package to use as a base";
  };
}
