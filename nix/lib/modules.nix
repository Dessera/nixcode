{
  pkgs,
  nix-vscode-extensions,
  nixcodeLib,
  ...
}:
let
  inherit (pkgs) lib system;
  ext = nix-vscode-extensions.overlays.default pkgs pkgs;
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
