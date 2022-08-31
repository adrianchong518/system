{ config, lib, pkgs, ... }:

{
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
