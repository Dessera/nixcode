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
      jeff-hykin.better-cpp-syntax
      llvm-vs-code-extensions.vscode-clangd
      twxs.cmake
      ms-vscode.cmake-tools
      cheshirekow.cmake-format
      ms-vscode.makefile-tools
      cschlosser.doxdocgen
      mesonbuild.mesonbuild
      tboox.xmake-vscode
    ])
    ++ (with pkgs.vscode-extensions; [
      vadimcn.vscode-lldb
    ]);
  deriveFrom = [ originalPackages.nix ];
}
