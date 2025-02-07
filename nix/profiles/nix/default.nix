{
  pkgs,
  ext,
  nixcodeLib,
  ...
}:
{
  extensions =
    (with pkgs.vscode-extensions; [
      jeff-hykin.better-nix-syntax
      jnoortheen.nix-ide
      smcpeak.default-keys-windows
      equinusocio.vsc-material-theme-icons
      equinusocio.vsc-material-theme
    ])
    ++ (with ext.vscode-marketplace; [
      igorsbitnev.error-gutters
      eamodio.gitlens
      mhutchie.git-graph
      yzhang.markdown-all-in-one
      aminer.codegeex
      aaron-bond.better-comments
      mkhl.direnv
      usernamehw.errorlens
      oderwat.indent-rainbow
      christian-kohler.path-intellisense
      gruntfuggly.todo-tree
      ms-ceintl.vscode-language-pack-zh-hans
    ]);

  settings = nixcodeLib.priority-utils.mkDefault_1 (
    builtins.fromJSON (builtins.readFile ./settings.json)
  );

  identifier = nixcodeLib.priority-utils.mkDefault_1 "nix";
}
