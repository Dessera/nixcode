{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.extensions;
in
{
  options.extensions = mkOption {
    type = types.listOf types.package;
    default = [ ];
    description = "Extensions for the vscode.";
  };

  config = mkIf (cfg != [ ]) {
    settings = {
      "extensions.autoCheckUpdates" = lib.mkDefault false;
      "update.mode" = lib.mkDefault "none";
    };
  };
}
