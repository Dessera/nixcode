{ ext, nixcodeLib, ... }:
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

  settings = nixcodeLib.priority-utils.mkDefault_2 (
    builtins.fromJSON (builtins.readFile ./settings.json)
  );

  identifier = nixcodeLib.priority-utils.mkDefault_2 "web";
}
