{
  nixcodeLib,
  codeExtensions,
  originalPackages,

  pkgs,
  ...
}:
let
  inherit (nixcodeLib) mkCode;
in
mkCode {
  inherit (pkgs) vscode;
  settings = builtins.fromJSON (builtins.readFile ./settings.json);
  extensions =
    (with codeExtensions.open-vsx; [
      charliermarsh.ruff
      njpwerner.autodocstring
      kevinrose.vsc-python-indent
    ])
    ++ (with codeExtensions.vscode-marketplace; [
      ms-python.python
      ms-python.debugpy
      ms-python.vscode-pylance
    ]);
  deriveFrom = [ originalPackages.nix ];
}
