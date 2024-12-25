{
  description = "Project-based Vscodium template instances";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      nix-vscode-extensions,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { flake-parts-lib, ... }:
      let
        inherit (flake-parts-lib) importApply;
      in
      {
        systems = [
          "x86_64-linux"
          "x86_64-darwin"
        ];
        imports = [
          (importApply ./packages { inherit nix-vscode-extensions; })
          ./lib
          ./devshells.nix
        ];
      }
    );
}