{ inputs, config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    global = {
      brewfile = true;
      noLock = true;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "homebrew/bundle"
    ];

    # "essential" brews, casks and apps
    brews = [
      "mas"
    ];

    casks = [
      # DE
      "kitty"
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

      # dev tools
      "visual-studio-code"

      # vm
      "utm"
    ];

    masApps = {
      Amphetamine = 937984704;
      Bitwarden = 1352778147;
    };
  };
}
