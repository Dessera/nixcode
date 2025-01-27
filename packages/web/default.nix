{
  nixcodeLib,
  codeExtensions,
  originalPackages,
  ...
}:
let
  inherit (nixcodeLib) mkCode;
in
mkCode {
  settings = builtins.fromJSON (builtins.readFile ./settings.json);
  extensions = with codeExtensions.open-vsx; [
    vue.volar
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    biomejs.biome
    denoland.vscode-deno
    bradlc.vscode-tailwindcss
  ];
  deriveFrom = [ originalPackages.nix ];
}
