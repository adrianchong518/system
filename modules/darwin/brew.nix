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
      "homebrew/core"
      "homebrew/services"
      "homebrew/bundle"
    ];
  };
}
