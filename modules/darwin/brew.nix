{ inputs, config, pkgs, ... }: {
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

    brews = [
      "mas"
    ];
  };
}
