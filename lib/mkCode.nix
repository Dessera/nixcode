{
  pkgs,
  name ? "nixcode",
  vscode ? pkgs.vscodium,
  settings ? { },
  isSettingsMutable ? false,
  extensions ? [ ],
  deriveFrom ? null,
}:
let
  inherit (pkgs) lib;

  # merge deriveFrom.settings & settings (settings comes first)
  derivedSettings =
    if deriveFrom != null then lib.recursiveUpdate deriveFrom.settings settings else settings;
  derivedExtensions =
    if deriveFrom != null then
      # no duplicates
      lib.lists.unique (extensions ++ deriveFrom.extensions)
    else
      extensions;

  instance = pkgs.vscode-with-extensions.override {
    inherit vscode;
    vscodeExtensions = derivedExtensions;
  };

  # write settings to a file (package)
  settingsFile = pkgs.writeText "settings.json" (builtins.toJSON derivedSettings);
  settingsFolder =
    (lib.lists.last (lib.splitString "/" settingsFile.outPath))
    + (if isSettingsMutable then "-mutable" else "");
  userPath = "$HOME/.vscode-nix/${settingsFolder}";
  settingsPath = "${userPath}/User/settings.json";

  exeName = if vscode == pkgs.vscodium then "codium" else "code";
  settingsCmd =
    if isSettingsMutable then
      ''
        if [ ! -f ${settingsPath} ]; then
          cp ${settingsFile} ${settingsPath}
        fi
      ''
    else
      ''
        if [ -f ${settingsPath} ]; then
          rm ${settingsPath}
        fi
        ln -s ${settingsFile} ${settingsPath}
      '';
in
{
  inherit name;
  unwrapped = instance;
  settings = derivedSettings;
  extensions = derivedExtensions;

  package = pkgs.writeShellScriptBin name ''
    if [ ! -d ${userPath}/User ]; then
      mkdir -p ${userPath}/User
    fi
    ${settingsCmd}
    ${instance}/bin/${exeName} --user-data-dir=${userPath} $PWD $@
  '';
}
