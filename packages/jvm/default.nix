{
  nixcodeLib,
  codeExtensions,
  originalPackages,

  pkgs,
}:
let
  nixLib = pkgs.lib;

  inherit (nixcodeLib) mkCode;
in
# TODO: trick to *add* override params, maybe a better way?
nixLib.makeOverridable (
  { jdk, ... }@overrideParams:
  (mkCode {
    settings = builtins.fromJSON (builtins.readFile ./settings.json);
    extensions = with codeExtensions.open-vsx; [
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-java-test
      vscjava.vscode-maven
      vscjava.vscode-gradle
      vscjava.vscode-java-dependency
    ];
    startupScripts = [
      ''
        # create $PWD/.vscode/settings.json for correct java home
        mkdir -p $PWD/.vscode
        echo '{ "java.jdt.ls.java.home": "${jdk}/lib/openjdk" }' > $PWD/.vscode/settings.json
      ''
    ];
    deriveFrom = [ originalPackages.nix ];
  }).override
    (builtins.removeAttrs overrideParams [ "jdk" ])
) { inherit (pkgs) jdk; }
