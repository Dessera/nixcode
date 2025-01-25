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
      tamasfe.even-better-toml
      ms-python.debugpy
    ])
    ++ (with codeExtensions.vscode-marketplace; [
      ms-python.python
      ms-python.vscode-pylance
    ]);
  deriveFrom = [ originalPackages.nix ];
}
