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
        };
      in
      ret;
  };
}
