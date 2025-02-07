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

  settings = nixcodeLib.priority-utils.mkDefault_2 (
    builtins.fromJSON (builtins.readFile ./settings.json)
  );

  identifier = nixcodeLib.priority-utils.mkDefault_2 "cpp";
}
