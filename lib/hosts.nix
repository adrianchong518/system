{ flake, inputs, lib, ... }:

with lib;
rec {
  isDarwinHost = hostType: hostType == "darwin";
  isNixosHost = hostType: hostType == "nixos";
  isHmHost = hostType: hostType == "hm";

  isManagedSystem = hostType: isDarwinHost hostType || isNixosHost hostType;

  mkDarwinHost =
    { path
    , system ? "aarch64-darwin"
    , hostName ? (removeSuffix ".nix" (baseNameOf path))
    , nixpkgs ? inputs.nixpkgs
    }:
    nameValuePair hostName (inputs.darwin.lib.darwinSystem
      {
        inherit system;
        specialArgs = {
          inherit flake inputs lib system nixpkgs;
          hostType = "darwin";
        };
        modules = [
          {
            networking.hostName = mkDefault hostName;
            modules.desktop.enable = mkDefault true;
          }
          ../modules
          (import path)
        ];
      });

  mkNixosHost =
    { path
    , system ? "x86_64-linux"
    , hostName ? (removeSuffix ".nix" (baseNameOf path))
    , nixpkgs ? inputs.nixos-unstable
    }:
    nameValuePair hostName (inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit flake inputs lib system nixpkgs;
        hostType = "nixos";
      };
      modules = [
        {
          networking.hostName = mkDefault hostName;
        }
        ../modules
        (import path)
      ];
    });

  mkHmHost =
    { path
    , system ? "x86_64-linux"
    , hostName ? (removeSuffix ".nix" (baseNameOf path))
    , nixpkgs ? inputs.nixpkgs
    }:
    homeManagerConfiguration rec {
      pkgs = import nixpkgs {
        inherit system;
      };
      specialArgs = {
        inherit flake inputs lib system hostName nixpkgs;
        hostType = "hm";
      };
      modules = [
        ../modules
        (import path)
      ];
    };
}
