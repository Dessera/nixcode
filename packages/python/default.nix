{
  nixcodeLib,
  codeExtensions,
  pkgs,
  originalPackages,
}:
let
  inherit (nixcodeLib) mkCode;
in
mkCode {
  inherit pkgs;
  settings = builtins.fromJSON (builtins.readFile ./settings.json);
  extensions = (
    with codeExtensions.open-vsx;
    [
      ms-python.python
      ms-pyright.pyright
      charliermarsh.ruff
      njpwerner.autodocstring
      kevinrose.vsc-python-indent
    ]
  );
  deriveFrom = [ originalPackages.nix ];
}
