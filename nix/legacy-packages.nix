{
  flake = {
    nixcodeProfiles = {
      cpp = import ./profiles/cpp;
      jvm = import ./profiles/jvm;
      nix = import ./profiles/nix;
      python = import ./profiles/python;
      rust = import ./profiles/rust;
      web = import ./profiles/web;
    };
  };
}
