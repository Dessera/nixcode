{
  pkgs,
  nix-vscode-extensions,
  nixcodeLib,
  ...
}:
let
  inherit (pkgs) lib system;
  ext = nix-vscode-extensions.extensions."${system}";
in
{
  evalCode =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
    }:
    lib.evalModules {
      modules = [ ../modules ] ++ modules;
      specialArgs = {
        inherit pkgs ext nixcodeLib;
      } // extraSpecialArgs;
    };
}
