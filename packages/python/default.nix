{
  nixcodeLib,
  codeExtensions,
  originalPackages,

  pkgs,
  ...
}:
let
  nixLib = pkgs.lib;

  inherit (nixcodeLib) mkCode;
in
nixLib.makeOverridable (
  { python, ... }@overrideParams:
  (mkCode {
    settings = builtins.fromJSON (builtins.readFile ./settings.json);
    extensions = (
      with codeExtensions.open-vsx;
      [
        ms-python.python
        ms-python.debugpy
        ms-pyright.pyright
        charliermarsh.ruff
        njpwerner.autodocstring
        kevinrose.vsc-python-indent
      ]
    );
    startupScripts = [
      ''
        mkdir -p $PWD/.vscode
        echo '{ "ruff.interpreter": [ "${python}/bin/python" ] }' > $PWD/.vscode/settings.json
      ''
    ];
    deriveFrom = [ originalPackages.nix ];
  }).override
    (builtins.removeAttrs overrideParams [ "python" ])
) { python = pkgs.python3; }
