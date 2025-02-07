{
  description = "Individual vscode instances for every workspace.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      nix-vscode-extensions,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, flake-parts-lib, ... }:
      let
        inherit (flake-parts-lib) importApply;
      in
      {
        systems = [ "x86_64-linux" ];

        imports = [ (importApply ./nix/lib { inherit nix-vscode-extensions; }) ];

        perSystem =
          { system, ... }:
          let
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };

            nixcodeLib = self.lib.mkLib pkgs;
          in
          {
            packages.default = nixcodeLib.packages.mkNixcode {
              modules = [ ./nix/profiles/nix ];
            };

            devShells = {
              default = pkgs.mkShell {
                packages = (
                  with pkgs;
                  [
                    nixd
                    nixfmt-rfc-style
                  ]
                );
              };
            };
          };
      }
    );
}
