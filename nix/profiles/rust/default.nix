{
  pkgs,
  ext,
  nixcodeLib,
  ...
}:
{
  imports = [
    ../nix
  ];

  extensions =
    (with ext.vscode-marketplace; [
      rust-lang.rust-analyzer
      dustypomerleau.rust-syntax
      fill-labs.dependi
      tamasfe.even-better-toml
    ])
    ++ (with pkgs.vscode-extensions; [
      vadimcn.vscode-lldb
    ]);

  identifier = nixcodeLib.priority-utils.mkDefault_2 "rust";
}
