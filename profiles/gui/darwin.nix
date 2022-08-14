{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenvNoCC.isDarwin {
  homebrew = {
    casks = [
      # DE
      "amethyst"

      # utils
      "appcleaner"
      "the-unarchiver"
      "transmission"
      "aldente"
      "monitorcontrol"

      # system monitoring
      "hot"
      "stats"

      # raycast
      "raycast"

      # browsers
      "firefox"

      # video playback
      "iina"

      # vm
      "utm"
    ];

    masApps = {
      Amphetamine = 937984704;
      Bitwarden = 1352778147;
    };
  };
}
