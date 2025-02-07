{ ext, nixcodeLib, ... }:
{
  imports = [
    ../nix
  ];

  extensions =
    (with ext.open-vsx; [
      charliermarsh.ruff
      njpwerner.autodocstring
      kevinrose.vsc-python-indent
      tamasfe.even-better-toml
      ms-python.debugpy
    ])
    ++ (with ext.vscode-marketplace; [
      ms-python.python
      ms-python.vscode-pylance
    ]);

  settings = nixcodeLib.priority-utils.mkDefault_2 (
    builtins.fromJSON (builtins.readFile ./settings.json)
  );

  identifier = nixcodeLib.priority-utils.mkDefault_2 "python";
}
