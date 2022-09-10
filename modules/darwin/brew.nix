{ inputs, config, pkgs, ... }:

{
  homebrew = {
    enable = true;

    global = {
      brewfile = true;
      autoUpdate = false;
    };

    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = false;
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
  };
}
