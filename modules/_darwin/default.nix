{ inputs, config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin;
in
{
  imports =
    importModulesRec ./.
    ++ [
      inputs.home-manager.darwinModules.home-manager
    ];

  assertions = [
    {
      assertion = cfg.homebrew.enable ||
        (all (l: length l == 0) [
          config.homebrew.brews
          config.homebrew.casks
          (attrsToList config.homebrew.masApps)
          config.homebrew.whalebrews
        ]);

      message = "Homebrew must be installed and enabled to install brews, casks, etc. with homebrew";
    }
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

  # FIXME: https://github.com/LnL7/nix-darwin/issues/701
  documentation.enable = false;

  system.stateVersion = 4;
}

