{ ... }:
{
  perSystem =
    { self', pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          nixfmt-rfc-style
          self'.packages.nix
        ];
      };
    };
}
