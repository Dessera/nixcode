{
  pkgs,
  ext,
  nixcodeLib,
  ...
}:
let
  inherit (nixcodeLib) module-utils priority-utils;
in
{
  extensions =
    (with pkgs.vscode-extensions; [
      jeff-hykin.better-nix-syntax
      jnoortheen.nix-ide
      smcpeak.default-keys-windows
    ])
    ++ (with ext.vscode-marketplace; [
      igorsbitnev.error-gutters
      eamodio.gitlens
      # mhutchie.git-graph
      yzhang.markdown-all-in-one
      aminer.codegeex
      aaron-bond.better-comments
      mkhl.direnv
      usernamehw.errorlens
      oderwat.indent-rainbow
      christian-kohler.path-intellisense
      gruntfuggly.todo-tree
      ms-ceintl.vscode-language-pack-zh-hans
      miguelsolorio.fluent-icons
      vscode-icons-team.vscode-icons
      tinaciousdesign.theme-tinaciousdesign
      davidanson.vscode-markdownlint
      liviuschera.noctis
    ]);

  settings = priority-utils.mapAttrset priority-utils.mkDefault_1 (
    module-utils.jsonFileToAttrs ./settings.json
  );

  identifier = priority-utils.mkDefault_1 "nix";
}
