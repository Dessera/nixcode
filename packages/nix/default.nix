{
  nixcodeLib,
  codeExtensions,
  ...
}:
let
  inherit (nixcodeLib) mkCode;
in
mkCode {
  settings = builtins.fromJSON (builtins.readFile ./settings.json);
  extensions =
    (with codeExtensions.vscode-marketplace; [
      jeff-hykin.better-nix-syntax
      igorsbitnev.error-gutters
      github.copilot
      eamodio.gitlens
      mhutchie.git-graph
      yzhang.markdown-all-in-one
      equinusocio.vsc-material-theme-icons
      equinusocio.vsc-material-theme
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
    ]);
}
