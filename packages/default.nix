packageParams: {
  nix = import ./nix packageParams;
  c_cpp = import ./c_cpp packageParams;
  python = import ./python packageParams;
  rust = import ./rust packageParams;
}
