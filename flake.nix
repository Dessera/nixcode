{
  description = "Individual vscode instances for every workspace.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      nix-vscode-extensions,
      flake-parts,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      {
        systems = [
          "x86_64-linux"
          "x86_64-darwin"
        ];
        imports = [
          # ./devshells.nix
        ];

        flake = {
          lib = import ./lib { inherit nixpkgs; };
        };

        perSystem =
          {
            self',
            system,
            pkgs,
            ...
          }:
          let
            nixcodeLib = self.lib;
            codeExtensions = nix-vscode-extensions.extensions."${system}";
            packageParams = {
              inherit
                pkgs
                nixcodeLib
                codeExtensions
                originalPackages
                ;
            };

            originalPackages = import ./packages packageParams;
          in
          {
            packages = builtins.mapAttrs (name: original: original.package) originalPackages;
            legacyPackages = originalPackages;

            devShells.default = pkgs.mkShell {
              packages = with pkgs; [
                nixd
                nixfmt-rfc-style
                self'.packages.nix
              ];
            };
          };
      }
    );
}
