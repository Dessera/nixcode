{ nix-vscode-extensions }:
{ self, ... }:
let
  nixcodeLib = self.lib;
in
{
  perSystem =
    {
      system,
      pkgs,
      ...
    }:
    let
      codeExtensions = nix-vscode-extensions.extensions."${system}";

      originalPackages =
        let
          packageParams = {
            inherit
              nixcodeLib
              codeExtensions
              pkgs
              originalPackages
              ;
          };
        in
        {
          nix = import ./nix packageParams;
          c_cpp = import ./c_cpp packageParams;
        };
    in
    {
      packages = builtins.mapAttrs (name: original: original.package) originalPackages;
    };
}
