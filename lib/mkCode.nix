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

  exeName = if (vscode == pkgs.vscodium || vscode == pkgs.vscodium-fhs) then "codium" else "code";

  innerPackage = nixcodeLib.mkScript {
    inherit
      pkgs
      name
      vscode
      instance
      userPath
      settingsFile
      isSettingsMutable
      ;
  };
in
{
  inherit name instance;
  inherit (derived) settings extensions;

  package = pkgs.callPackage (
    {
      stdenv,
      makeDesktopItem,
      copyDesktopItems,
    }:
    stdenv.mkDerivation {
      inherit name;

      nativeBuildInputs = [ copyDesktopItems ];

      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p $out/bin
        cp ${innerPackage}/bin/${name} $out/bin/${name}

        runHook postInstall
      '';

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
    }
  ) { };
}
