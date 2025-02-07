{ ... }:
{
  jsonFileToAttrs = p: builtins.fromJSON (builtins.readFile p);
}
