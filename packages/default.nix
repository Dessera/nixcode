{ nix-vscode-extensions }:
{ self, ... }:
let
  nixcodeLib = self.lib;
in
{
  perSystem =
    { system, pkgs, ... }:
    let
      codeExtensions = nix-vscode-extensions.extensions."${system}";
      packageParams = { inherit nixcodeLib codeExtensions pkgs; };
    in
    {
      packages.nix = (import ./nix packageParams).package;
    };
}
