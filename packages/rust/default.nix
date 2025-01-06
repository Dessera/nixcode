{
  nixcodeLib,
  codeExtensions,
  pkgs,
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
      rust-lang.rust-analyzer
      lyonsyonii.rust-syntax
      fill-labs.dependi
      tamasfe.even-better-toml
    ])
    ++ (with pkgs.vscode-extensions; [
      vadimcn.vscode-lldb
    ]);
  deriveFrom = [ originalPackages.nix ];
}
