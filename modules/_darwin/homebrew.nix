{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  inherit (pkgs.stdenvNoCC) isAarch64 isAarch32;

  cfg = config.modules.darwin.homebrew;
in
{
  options.modules.darwin.homebrew = {
    enable = mkBoolOpt false;
  };

  config.homebrew = mkIf cfg.enable {
    enable = true;

    brewPrefix = if isAarch64 || isAarch32 then "/opt/homebrew/bin" else "/usr/local/bin";

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
