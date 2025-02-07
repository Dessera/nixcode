{
  pkgs,
  nixcodeLib,
  ...
}:
let
  inherit (pkgs) vscode-utils lib;
in
rec {
  mkNixcodeSettings =
    module:
    let
      inherit (module.config) settings identifier pname;
    in
    pkgs.writeTextFile {
      name = "${pname}-${identifier}-settings-json";
      destination = "/share/vscode/settings.json";
      text = builtins.toJSON settings;
    };

  mkNixcodeExtensions =
    module:
    let
      inherit (module.config) extensions identifier pname;

      extensionJsonFile = pkgs.writeTextFile {
        name = "${pname}-${identifier}-extensions-json";
        destination = "/share/vscode/extensions/extensions.json";
        text = vscode-utils.toExtensionJson extensions;
      };
    in
    pkgs.buildEnv {
      name = "${pname}-${identifier}-extensions";
      paths = [ extensionJsonFile ] ++ extensions;
    };

  mkNixcodeProfile =
    module:
    let
      inherit (module.config) identifier pname;
      settings = mkNixcodeSettings module;
      extensions = mkNixcodeExtensions module;
    in
    pkgs.symlinkJoin {
      name = "${pname}-${identifier}-profile";
      paths = [
        settings
        extensions
      ];
    };

  mkUserDataPath =
    {
      profile,
      basePath,
    }:
    let
      folderName = (lib.lists.last (lib.splitString "/" profile.outPath));
    in
    "${basePath}/${folderName}";

  mkStartupScript =
    {
      module,
      profile,
      basePath,
    }:
    let
      inherit (module.config) package;
      exeName = package.meta.mainProgram;
      exePath = "${package}/bin/${exeName}";
      userDataPath = mkUserDataPath { inherit profile basePath; };
    in
    pkgs.writeShellScriptBin exeName ''
      if [ ! -d "${userDataPath}/User" ]; then
        mkdir -p "${userDataPath}/User"
      fi
      if [ -e "${userDataPath}/User/settings.json" ]; then
        rm -f "${userDataPath}/User/settings.json"
      fi
      cp ${profile}/share/vscode/settings.json ${userDataPath}/User/settings.json
      exec ${exePath} $@ --extensions-dir ${profile}/share/vscode/extensions --user-data-dir ${userDataPath}
    '';

  mkNixcode =
    {
      modules,
      basePath ? "$HOME/.vscode-nix/global",
    }:
    let
      module = nixcodeLib.modules.evalCode {
        inherit modules;
      };
      profile = mkNixcodeProfile module;

      inherit (module.config) identifier pname;
      package = module.config.package;
      script = mkStartupScript { inherit module profile basePath; };
    in
    pkgs.symlinkJoin {
      name = "${pname}-${identifier}";
      paths = [
        script
        package
      ];
    };
}
