{
  flake = {
    nixcodeProfiles = {
      nix = import ./profiles/nix;
    };
  };
}
