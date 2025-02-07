{
  flake = {
    nixcodeProfiles = {
      cpp = import ./cpp;
      jvm = import ./jvm;
      nix = import ./nix;
      python = import ./python;
      rust = import ./rust;
      web = import ./web;
    };
  };
}
