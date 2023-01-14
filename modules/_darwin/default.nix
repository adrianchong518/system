{ inputs, config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  imports =
    importModulesRec ./.
    ++ [
      inputs.home-manager.darwinModules.home-manager
    ];

  # environment setup
  environment.etc.darwin.source = "${inputs.darwin}";

  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
  ];

  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # auto manage nixbld users with nix darwin
  nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  system.stateVersion = 4;
}

