{ ext, nixcodeLib, ... }:
let
  inherit (nixcodeLib) module-utils priority-utils;
in
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

  settings = priority-utils.mapAttrset priority-utils.mkDefault_2 (
    module-utils.jsonFileToAttrs ./settings.json
  );

  identifier = priority-utils.mkDefault_2 "python";
}
