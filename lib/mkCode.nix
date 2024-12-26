nixcodeLib:
{
  pkgs,
  name ? "nixcode",
  desktopName ? "Nixcode",
  description ? "Individual vscode instances for every workspace.",

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
  inherit name instance;
  inherit (derived) settings extensions;

  package =
    let
      inherit (pkgs) makeDesktopItem;
    in
    (pkgs.writeShellScriptBin name ''
      if [ ! -d ${userPath}/User ]; then
        mkdir -p ${userPath}/User
      fi
      ${settingsCmd}
      ${instance}/bin/${exeName} --user-data-dir=${userPath} $@
    '').overrideAttrs
      (oldAttrs: {
        desktopItems = [
          (makeDesktopItem {
            inherit name desktopName;
            comment = description;
            genericName = "Text Editor";
            exec = "${name} %F";

            # TODO: modify icon
            icon = "vs${exeName}";
            startupNotify = true;
            startupWMClass = exeName;
            categories = [
              "Utility"
              "TextEditor"
              "Development"
              "IDE"
            ];
            keywords = [ "vscode" ];
            actions.new-empty-window = {
              name = "New Empty Window";
              exec = "${name} --new-window %F";
              icon = "vs${exeName}";
            };
          })
        ];
      });
}
