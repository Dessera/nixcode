{ pkgs, lib, ... }:
let
  inherit (lib) mkOption types;

  json = pkgs.formats.json { };
in
{
  options.keybindings = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          key = mkOption {
            type = types.str;
            description = "The key or key-combination to bind.";
          };

          command = mkOption {
            type = types.str;
            description = "The VS Code command to execute.";
          };

          when = mkOption {
            type = types.nullOr (types.str);
            default = null;
            description = "Optional context filter.";
          };

          args = mkOption {
            type = types.nullOr (types.attrsOf json.type);
            default = null;
            description = "Optional arguments for a command.";
          };
        };
      }
    );
    default = [ ];
    description = "Keybindings for VS Code.";
  };
}
