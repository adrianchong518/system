{ inputs, config, pkgs, ... }:

{
  homebrew = {
    enable = true;

    global = {
      brewfile = true;
      noLock = true;
    };

    cleanup = "zap";

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
  };
}
