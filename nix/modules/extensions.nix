{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.extensions = mkOption {
    type = types.listOf types.package;
    default = [ ];
    description = "Extensions for the vscode.";
  };
}
