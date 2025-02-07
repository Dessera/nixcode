{ ext, nixcodeLib, ... }:
let
  inherit (nixcodeLib) module-utils priority-utils;
in
{
  imports = [
    ../nix
  ];

  extensions = with ext.vscode-marketplace; [
    vue.volar
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    biomejs.biome
    denoland.vscode-deno
    bradlc.vscode-tailwindcss
  ];

  settings = priority-utils.mapAttrset priority-utils.mkDefault_2 (
    module-utils.jsonFileToAttrs ./settings.json
  );

  identifier = priority-utils.mkDefault_2 "web";
}
