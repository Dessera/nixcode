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
          ./lib
        ];

        perSystem =
          {
            self',
            pkgs,
            system,
            ...
          }:
          let
            nixcodeLib = self.lib.mkLib { inherit pkgs; };
            codeExtensions = nix-vscode-extensions.extensions."${system}";
            originalPackages = import ./packages packageParams;
            packageParams = {
              inherit
                pkgs
                nixcodeLib
                codeExtensions
                originalPackages
                ;
            };
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
