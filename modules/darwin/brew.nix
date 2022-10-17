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
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];

    # "essential" brews, casks and apps
    brews = [
      "mas"
    ];
  };
}
