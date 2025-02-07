{ pkgs, lib, ... }:
let
  inherit (lib) mkOption types;

  json = pkgs.formats.json { };
in
{
  options.snippets = {
    global = mkOption {
      type = types.attrsOf (json.type);
      default = { };
      description = "Global snippets";
    };

    languageSpecific = mkOption {
      type = types.attrsOf (types.attrsOf (json.type));
      default = { };
      description = "Language-specific snippets";
    };
  };
}
