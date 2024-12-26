lib:
{
  settingsFile,
  isSettingsMutable ? false,
  baseDir ? "$HOME/.vscode-nix",
}:
let
  folderName =
    (lib.lists.last (lib.splitString "/" settingsFile.outPath))
    + (if isSettingsMutable then "-mutable" else "");
in
"${baseDir}/${folderName}"
