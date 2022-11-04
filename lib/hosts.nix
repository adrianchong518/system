{ flake, inputs, lib, ... }:

with lib;
with lib.my;
let
  commonModules = [
    ../config
    ../modules
  ];
in
rec {
  isDarwinHost = hostType: hostType == "darwin";
  isNixosHost = hostType: hostType == "nixos";
  isLinuxHost = hostType: hostType == "linux";

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
          (import path)
        ]
        ++ commonModules;
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
        (import path)
      ]
      ++ commonModules;
    });

  mkLinuxHost =
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
        hostType = "linux";
      };

      modules = [
        (import path)
      ]
      ++ commonModules;
    };
}
