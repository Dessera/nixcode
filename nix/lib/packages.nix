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

  mkNixcodeKeybindings =
    module:
    let
      inherit (module.config) keybindings identifier pname;
      filteredKeybindings = map (lib.filterAttrs (n: v: v != null)) keybindings;
    in
    pkgs.writeTextFile {
      name = "${pname}-${identifier}-keybindings-json";
      destination = "/share/vscode/keybindings.json";
      text = builtins.toJSON filteredKeybindings;
    };

  mkNixcodeSnippets =
    module:
    let
      inherit (module.config) snippets identifier pname;
      languages = lib.mapAttrsToList (
        l: s:
        (pkgs.writeTextFile {
          name = "${pname}-${identifier}-${l}-snippets-json";
          destination = "/share/vscode/snippets/${l}.json";
          text = builtins.toJSON s;
        })
      ) snippets.languageSpecific;
      global = pkgs.writeTextFile {
        name = "${pname}-${identifier}-global-snippets-json";
        destination = "/share/vscode/snippets/global.code-snippets";
        text = builtins.toJSON snippets.global;
      };
    in
    languages ++ [ global ];

  mkNixcodeUserTasks =
    module:
    let
      inherit (module.config) userTasks identifier pname;
    in
    pkgs.writeTextFile {
      name = "${pname}-${identifier}-user-tasks-json";
      destination = "/share/vscode/tasks.json";
      text = builtins.toJSON userTasks;
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
      keybindings = mkNixcodeKeybindings module;
      snippets = mkNixcodeSnippets module;
      tasks = mkNixcodeUserTasks module;
    in
    pkgs.symlinkJoin {
      name = "${pname}-${identifier}-profile";
      paths = [
        settings
        extensions
        keybindings
        tasks
      ] ++ snippets;
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
      inherit (module.config) package snippets;
      exeName = package.meta.mainProgram;
      exePath = "${package}/bin/${exeName}";
      userDataPath = mkUserDataPath { inherit profile basePath; };

      languages = lib.mapAttrsToList (l: _: l) snippets.languageSpecific;

      initUserFile = fname: ''
        if [ -e "${userDataPath}/User/${fname}" ]; then
          rm -f "${userDataPath}/User/${fname}"
        fi
        cp ${profile}/share/vscode/${fname} ${userDataPath}/User/${fname}
      '';
      languagesInit = map (l: initUserFile "snippets/${l}.json") languages;
    in
    pkgs.writeShellScriptBin exeName ''
      if [ ! -d "${userDataPath}/User/snippets" ]; then
        mkdir -p "${userDataPath}/User/snippets"
      fi

      ${initUserFile "settings.json"}
      ${initUserFile "keybindings.json"}
      ${initUserFile "snippets/global.code-snippets"}
      ${lib.concatStringsSep "\n" languagesInit}
      ${initUserFile "tasks.json"}

      exec ${exePath} --extensions-dir ${profile}/share/vscode/extensions --user-data-dir ${userDataPath} $@
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

      inherit (module.config) identifier pname package;
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
