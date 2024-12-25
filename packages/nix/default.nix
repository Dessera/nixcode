{
  nixcodeLib,
  codeExtensions,
  pkgs,
}:
let
  inherit (nixcodeLib) mkCode;
in
mkCode {
  inherit pkgs;
  settings = builtins.fromJSON (builtins.readFile ./settings.json);
  isSettingsMutable = true;
  extensions =
    (with codeExtensions.vscode-marketplace; [
      jeff-hykin.better-nix-syntax
      igorsbitnev.error-gutters
      github.copilot
      eamodio.gitlens
      mhutchie.git-graph
    ])
    ++ (with codeExtensions.open-vsx; [
      aaron-bond.better-comments
      mkhl.direnv
      usernamehw.errorlens
      oderwat.indent-rainbow
      jnoortheen.nix-ide
      christian-kohler.path-intellisense
      gruntfuggly.todo-tree
      jeanp413.open-remote-ssh
      ms-ceintl.vscode-language-pack-zh-hans
    ])
    ++ (with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      equinusocio.vsc-material-theme-icons
    ]);
}
