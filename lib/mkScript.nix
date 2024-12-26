{
  pkgs,
  name,
  vscode,
  instance,
  userPath,
  settingsFile,
  isSettingsMutable,
}:
let
  settingsPath = "${userPath}/User/settings.json";
  exeName = if (vscode == pkgs.vscodium || vscode == pkgs.vscodium-fhs) then "codium" else "code";

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
pkgs.writeShellScriptBin name ''
  if [ ! -d ${userPath}/User ]; then
    mkdir -p ${userPath}/User
  fi
  ${settingsCmd}
  ${instance}/bin/${exeName} --user-data-dir=${userPath} $@
''
