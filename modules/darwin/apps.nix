{ config, lib, pkgs, ... }: {
  homebrew = {
    casks = [
      # system utils
      "kitty"
      "amethyst"
      "appcleaner"

      # system monitoring
      "hot"

      # browsers
      "firefox"
      "iina"
    ];

    masApps = {
      Amphetamine = 937984704;
      Bitwarden = 1352778147;
      EasyRes = 688211836;
    };
  };
}
