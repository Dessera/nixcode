{
  pkgs,
  ext,
  lib,
  ...
}:
{
  extensions =
    (with pkgs.vscode-extensions; [
      jeff-hykin.better-nix-syntax
      jnoortheen.nix-ide
    ])
    ++ (with ext.vscode-marketplace; [
      igorsbitnev.error-gutters
      eamodio.gitlens
      mhutchie.git-graph
      yzhang.markdown-all-in-one
      equinusocio.vsc-material-theme-icons
      equinusocio.vsc-material-theme
      aminer.codegeex
      aaron-bond.better-comments
      mkhl.direnv
      usernamehw.errorlens
      oderwat.indent-rainbow
      christian-kohler.path-intellisense
      gruntfuggly.todo-tree
      ms-ceintl.vscode-language-pack-zh-hans
    ]);

  settings = builtins.fromJSON (builtins.readFile ./settings.json);

  identifier = lib.mkDefault "nix";
}
