{ pkgs, lib, ... }:
let
  inherit (lib) mkOption types;

  json = pkgs.formats.json { };
in
{
  options.userTasks = mkOption {
    type = types.attrsOf json.type;
    default = { };
    description = "User tasks";
  };
}
