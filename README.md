# Nixcode

Individual vscode instances for every workspace.

## Usage

Include the flake into your flake.nix and use mkCode to create your own code instance.

Here is an example of making a blank vscodium:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixcode.url = "github:Dessera/nixcode";
  };

  outputs =
    {
      flake-parts,
      nixcode,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          packages.default = (nixcode.lib.mkCode {
            inherit pkgs;
            settings = { };
            extensions = [ ];
          }).package;
        };
    };
}
```

> For extensions, check `pkgs.vscode-extensions` or view [nix-vscode-extensions](https://github.com/nix-community/nix-vscode-extensions)

## API

### mkCode

Arguments:

```nix
{
  pkgs,
  name ? "nixcode",
  vscode ? pkgs.vscodium,
  settings ? { },
  isSettingsMutable ? false,
  extensions ? [ ],
  deriveFrom ? [ ],
}
```

Return:

```nix
{
  name = ...;         # executable name
  unwrapped = ...;    # original executable
  settings = ...;     # settings (nix object)
  extensions = ...;   # extensions (nix packages)

  package = ...;      # final package (shell script)
}
```

### Notice

1. all user data was saved in `$HOME/.vscode-nix/`
2. Some extensions may not work well (especially theme extensions)
