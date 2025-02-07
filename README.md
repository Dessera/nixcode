# Nixcode

Individual vscode instances for every workspace.

## STATUS

I'm working on refactoring the code to be more functional with a python startup script rather than a bash script.

## Startup steps

1. check user data directory
   
   - if not exist, create it
   - link settings, keybindings, snippets, etc.

2. check extensions
   
   - there is a list to point out which extensions to be mutable
   - copy mutable extensions to extensions folder (if not exist)
   - link immutable extensions to extensions folder (if not exist)
   - pass extensions to vscode

$HOME/.vscode-nix/extensions/<hash>-<pname>/    # extensions folder
$HOME/.vscode-nix/global/<hash>-<pname>/        # user data folder (shared global storage)

## Usage

code $@                       # just like normal vscode
nixcode                       # a cli to manage nixcode profiles

mkCode {
   modules = [
      {
         settings = { ... };
         keybindings = { ... };
         snippets = { ... };
      }
      ({ ext, pkgs, ... }: {
         extensions = [ ... ];
         initializer = [ ... ];

         runtimeSettings = { ... }: { ... };    # package
      })
   ];
} -> drv

drv:

runtimeSettingsArgs // fixedArgs => derivation;

instance (which is a drv)
instance.overrideRuntimeSettingsArgs 
or instance.override { runtimeSettingsArgs = { ... }; }
or instance.overrideAttrs (old: { runtimeSettingsArgs = { ... }; })
