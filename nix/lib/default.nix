{ nix-vscode-extensions }:
{
  flake = {
    lib.mkLib =
      pkgs:
      let
        ret = {
          modules = import ./modules.nix {
            inherit pkgs nix-vscode-extensions;
            nixcodeLib = ret;
          };
          packages = import ./packages.nix {
            inherit pkgs nix-vscode-extensions;
            nixcodeLib = ret;
          };
          priority-utils = import ./priority-utils.nix {
            inherit pkgs nix-vscode-extensions;
            nixcodeLib = ret;
          };

          module-utils = import ./module-utils.nix {
            inherit pkgs nix-vscode-extensions;
            nixcodeLib = ret;
          };
        };
      in
      ret;
  };
}
