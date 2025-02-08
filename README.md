# Nixcode

![Visual Studio Code](https://custom-icon-badges.demolab.com/badge/Visual%20Studio%20Code-0078d7.svg?logo=vsc&logoColor=white)
![VSCodium](https://img.shields.io/badge/VSCodium-2F80ED?logo=vscodium&logoColor=fff)
![Nix](https://img.shields.io/badge/Nix-5277C3?logo=nixos&logoColor=fff)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/Dessera/nixcode/cachix.yml)
![Maintainer](https://img.shields.io/badge/maintainer-Dessera-red)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/Dessera/nixcode)


📦 Individual vscode instances for every workspace.

## Usage

### Use prebuilt packages

1. Add this flake to your `flake.nix`
2. Use packages in `nixcode.packages.${system}`

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixcode.url = "github:Dessera/nixcode";
  };

  outputs = { self, nixpkgs, nixcode }: {
    packages.x86_64-linux = {
      default = nixcode.packages.x86_64-linux.nix;  # use `nix` profile
    };
  };
}
```

You can use `cachix` in `flake.nix` to avoid building the packages yourself.

```nix
{
  # inputs ...

  nixConfig = {
    extra-substituters = [
      "https://nixcode.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nixcode.cachix.org-1:6FvhF+vlN7gCzQ10JIKVldbG59VfYVzxhH/+KGHvMhw="
    ];
  };

  # outputs ...
}
```

### Build your own profile

1. Add this flake to your `flake.nix`
2. Use `nixcode.lib.mkLib` to create a `nixcodeLib`
3. use `nixcodeLib.mkNixcode` to create a `nixcode` profile

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixcode.url = "github:Dessera/nixcode";
  };

  outputs = { self, nixpkgs, nixcode }: 
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    nixcodeLib = nixcode.lib.mkLib pkgs;
  in
  {
    packages.x86_64-linux = {
      default = nixcodeLib.mkNixcode {
        modules = [
          # your modules here

          # reuse nixcode modules
          nixcode.nixcodeProfiles.nix

          # combine multiple nixcode profiles (should override some options to avoid conflicts)
          nixcode.nixcodeProfiles.web
          nixcode.nixcodeProfiles.rust
          { identifier = "tauri"; }
        ];
      };
    };
  };
}
```

## API Reference

TODO

## STATUS

Need documentation



