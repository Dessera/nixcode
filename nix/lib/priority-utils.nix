# TODO: Too ugly
{
  pkgs,
  ...
}:
let
  inherit (pkgs) lib;
in
{
  mkDefault_1 = lib.mkDefault;
  mkDefault_2 = lib.mkOverride 900;
  mkDefault_3 = lib.mkOverride 800;
  mkDefault_4 = lib.mkOverride 700;
  mkDefault_5 = lib.mkOverride 600;
  mkDefault_6 = lib.mkOverride 500;
  mkDefault_7 = lib.mkOverride 400;
  mkDefault_8 = lib.mkOverride 300;

  mapAttrset = f: lib.attrsets.mapAttrsRecursive (_: v: f v);
}
