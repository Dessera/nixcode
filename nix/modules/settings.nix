{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.settings = mkOption {
    type = types.attrs;
    default = { };
    description = "Settings for the vscode.";
  };
}
