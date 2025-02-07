{ pkgs, lib, ... }:
let
  inherit (lib) mkOption types;

  json = pkgs.formats.json { };
in
{
  options.settings = mkOption {
    type = types.attrsOf json.type;
    default = { };
    description = "Settings for the vscode.";
  };
}
