nixcodeLib:
{
  pkgs,
  name ? "nixcode",
  vscode ? pkgs.vscodium,
  settings ? { },
  isSettingsMutable ? false,
  extensions ? [ ],
  deriveFrom ? [ ],
}:
let
  derived = nixcodeLib.mkDerive {
    inherit settings extensions deriveFrom;
  };

  instance = pkgs.vscode-with-extensions.override {
    inherit vscode;
    vscodeExtensions = derived.extensions;
  };

  settingsFile = pkgs.writeText "settings.json" (builtins.toJSON derived.settings);
  userPath = nixcodeLib.mkUserData {
    inherit settingsFile isSettingsMutable;
  };
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
{
  inherit name;
  inherit (derived) settings extensions;
  unwrapped = instance;

  package = pkgs.writeShellScriptBin name ''
    if [ ! -d ${userPath}/User ]; then
      mkdir -p ${userPath}/User
    fi
    ${settingsCmd}
    ${instance}/bin/${exeName} --user-data-dir=${userPath} $PWD $@
  '';
}
