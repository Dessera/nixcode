{
  ext,
  nixcodeLib,
  ...
}:
{
  imports = [
    ../nix
  ];

  extensions = with ext.vscode-marketplace; [
    redhat.java
    vscjava.vscode-java-debug
    vscjava.vscode-java-test
    vscjava.vscode-maven
    vscjava.vscode-gradle
    vscjava.vscode-java-dependency
  ];

  identifier = nixcodeLib.priority-utils.mkDefault_2 "jvm";
}
