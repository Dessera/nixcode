lib:
{
  settings,
  extensions,
  deriveFrom,
  ...
}:
{
  settings = builtins.foldl' (
    final: current: lib.recursiveUpdate current.settings final
  ) settings deriveFrom;
  extensions = lib.lists.unique (extensions ++ lib.lists.concatMap (ext: ext.extensions) deriveFrom);
}
