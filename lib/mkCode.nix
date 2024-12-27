nixcodeLib:
{
  pkgs,
  vscode ? pkgs.vscodium,
  settings ? { },
  isSettingsMutable ? false,
  extensions ? [ ],
  deriveFrom ? [ ],

  name ? "nixcode",
  desktopName ? "Nixcode",
  description ? "Individual vscode instances for every workspace.",
  icon ? vscode.pname,
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
in
{
  inherit name instance;
  inherit (derived) settings extensions;

  package = pkgs.callPackage (
    {
      stdenv,
      copyDesktopItems,
      makeDesktopItem,
      substitute,
    }:
    let
      scriptBin = substitute {
        src = ./assets/nixcode-inner.sh;
        substitutions = [
          "--replace-quiet"
          "PATH_TO_USER_DATA"
          userPath
          "--replace-quiet"
          "IS_SETTINGS_MUTABLE"
          (if isSettingsMutable then "true" else "false")
          "--replace-quiet"
          "PATH_TO_SETTINGS"
          settingsFile
          "--replace-quiet"
          "CODE_INSTANCE"
          "${instance}/bin/${instance.meta.mainProgram}"
        ];
      };
      makeShellCommand = cmd: ''
        ${pkgs.stdenv.shell} -c "${cmd}"
      '';
    in
    stdenv.mkDerivation {
      inherit name;
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/bin
        cp ${scriptBin} $out/bin/${name}
        chmod +x $out/bin/${name}

        runHook postInstall
      '';

      nativeBuildInputs = [ copyDesktopItems ];
      desktopItems = [
        (makeDesktopItem {
          inherit name desktopName icon;
          comment = description;
          genericName = "Text Editor";
          exec = makeShellCommand "${name} %F";
          startupNotify = true;
          startupWMClass = name;
          categories = [
            "Utility"
            "TextEditor"
            "Development"
            "IDE"
          ];
          keywords = [ "vscode" ];
          actions.new-empty-window = {
            name = "New Empty Window";
            exec = makeShellCommand "${name} --new-window %F";
            inherit icon;
          };
        })
        (makeDesktopItem {
          inherit icon;
          name = name + "-url-handler";
          desktopName = desktopName + " - URL Handler";
          comment = description;
          genericName = "Text Editor";
          exec = makeShellCommand "${name} --open-url %U";
          startupNotify = true;
          startupWMClass = name;
          categories = [
            "Utility"
            "TextEditor"
            "Development"
            "IDE"
          ];
          mimeTypes = [ "x-scheme-handler/${vscode.pname}" ];
          keywords = [ "vscode" ];
          noDisplay = true;
        })
      ];
    }
  ) { };
}
