{
  flake = {
    lib.mkLib =
      { pkgs }:
      let
        nixLib = pkgs.lib;

        ret = {
          mkCode = nixLib.makeOverridable (
            {
              name ? "nixcode",
              vscode ? pkgs.vscode,
              settings ? { },
              isSettingsMutable ? false,
              startupScripts ? [ ],
              extensions ? [ ],
              deriveFrom ? [ ],
            }:
            let
              derived = ret.mkDeriveCode {
                inherit
                  settings
                  extensions
                  startupScripts
                  deriveFrom
                  ;
              };

              script = ret.mkCodeScript {
                inherit vscode isSettingsMutable;
                inherit (derived) settings extensions startupScripts;
              };
            in
            {
              inherit name;
              inherit (derived) settings extensions startupScripts;

              package = pkgs.symlinkJoin {
                inherit name;
                paths = [
                  script
                  vscode
                ];
              };
            }
          );

          mkDeriveCode =
            {
              settings,
              extensions,
              startupScripts,
              deriveFrom,
            }:
            {
              settings = builtins.foldl' (
                final: current: nixLib.recursiveUpdate current.settings final
              ) settings deriveFrom;
              extensions = nixLib.lists.unique (
                extensions ++ nixLib.lists.concatMap (ext: ext.extensions) deriveFrom
              );
              startupScripts = startupScripts ++ nixLib.lists.concatMap (ext: ext.startupScripts) deriveFrom;
            };

          mkSettings = settings: pkgs.writeText "settings.json" (builtins.toJSON settings);

          mkUserPath =
            {
              settingsFile,
              isSettingsMutable,
              baseDir ? "$HOME/.vscode-nix",
            }:
            let
              folderName =
                (nixLib.lists.last (nixLib.splitString "/" settingsFile.outPath))
                + (if isSettingsMutable then "-mutable" else "");
            in
            "${baseDir}/${folderName}";

          mkCodeScript =
            {
              vscode,
              settings,
              isSettingsMutable,
              startupScripts,
              extensions,
            }:
            let
              codeInstance = pkgs.vscode-with-extensions.override {
                inherit vscode;
                vscodeExtensions = extensions;
              };
              settingsFile = ret.mkSettings settings;
              userPath = ret.mkUserPath {
                inherit settingsFile isSettingsMutable;
              };

              configDeployer = ''
                if [ ! -d ${userPath} ]; then
                  mkdir -p ${userPath}/User
                fi
                if [ -e ${userPath}/User/settings.json ]; then
                  rm -rf ${userPath}/User/settings.json
                fi
                ${if isSettingsMutable then "cp" else "ln -s"} ${settingsFile} ${userPath}/User/settings.json
              '';

              # concat startup scripts
              startupScript = nixLib.concatStringsSep "\n" startupScripts;

              # execute vscode
              execScript = ''
                ${codeInstance}/bin/${codeInstance.meta.mainProgram} --user-data-dir=${userPath} $@
              '';
            in
            pkgs.writeShellScriptBin codeInstance.meta.mainProgram ''
              ${configDeployer}
              ${startupScript}
              ${execScript}
            '';
        };
      in
      ret;
  };
}
