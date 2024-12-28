{ nixpkgs }:
let
  nixcodeLib = {
    # Function to make code instances
    mkCode = import ./mkCode.nix nixcodeLib;

    # Function to make user data path (mutable position)
    mkUserData = import ./mkUserData.nix nixpkgs.lib;

    # Function to derive settings and extensions from parents
    mkDerive = import ./mkDerive.nix nixpkgs.lib;

  };
in
nixcodeLib
