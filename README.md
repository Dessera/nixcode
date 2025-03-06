# Nixcode

![Visual Studio Code](https://custom-icon-badges.demolab.com/badge/Visual%20Studio%20Code-0078d7.svg?logo=vsc&logoColor=white)
![VSCodium](https://img.shields.io/badge/VSCodium-2F80ED?logo=vscodium&logoColor=fff)
![Nix](https://img.shields.io/badge/Nix-5277C3?logo=nixos&logoColor=fff)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/Dessera/nixcode/cachix.yml)
![Maintainer](https://img.shields.io/badge/maintainer-Dessera-red)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/Dessera/nixcode)

:package: Individual vscode instances for every workspace.

## :compass: Usage

### :sparkles: Use prebuilt packages :sparkles:

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

### :sailboat: Build your own profile :sailboat:

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

## :hammer_and_wrench: API Reference

> :warning: Some functions are not documented here because they're used internally.

### Library reference

1. `packages.mkNixcode`:

    create a `nixcode` package from modules.

    ```nix
    mkNixcode {
      modules = [ 
        # see: Module reference
      ];
    }
    ```

### Module reference

```nix
{ pkgs, ext, nixcodeLib, ... }:
{
  extensions = [ ];
  settings = [ ];
  keybindings = { };
  snippets = {
    global = { };
    languageSpecific = { };
  };
  userTasks = { };

  identifier = "...";
  pname = "...";
  package = pkgs.vscode;
}
```

- `ext`: an extension set for vscode, see [nix-vscode-extensions](https://github.com/nix-community/nix-vscode-extensions).

- `nixcodeLib`: nixcode library.

- `identifier`: used to identify the package, final name will be `${pname}-${identifier}`.

- `pname`: used to name the package, final name will be `${pname}-${identifier}`.

- `package`: vscode package to use.

- `extensions`: a list of extension packages to install.

- `settings`: attrs written in `settings.json` file.

- `keybindings`: attrs written in `keybindings.json` file.

- `snippets.global`: snippets written in `snippets/global.code-snippets` file.

- `snippets.languageSpecific`: snippets written in `snippets/${language}.json` file.

  ```nix
  # example
  {
    snippets.languageSpecific = {
      nix = {
        # ...
      };
    }
  }
  ```

- `userTasks` : user tasks written in `tasks.json` file.
