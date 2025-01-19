{
  nixcodeLib,
  codeExtensions,
  originalPackages,
  ...
}:
let
  inherit (nixcodeLib) mkCode;
in
mkCode {
  settings = builtins.fromJSON (builtins.readFile ./settings.json);
  extensions =
    (with codeExtensions.open-vsx; [
      charliermarsh.ruff
      njpwerner.autodocstring
      kevinrose.vsc-python-indent
    ])
    ++ (with codeExtensions.vscode-marketplace; [
      ms-pyright.pyright
      ms-python.python
      ms-python.debugpy
    ]);
  deriveFrom = [ originalPackages.nix ];
}
