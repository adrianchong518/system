{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.darwin.desktop.apps.playcover;
in {
  options.modules.darwin.desktop.apps.playcover = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew = {
      taps = [ "PlayCover/playcover" ];
      casks = [ "playcover-community" ];
    };
  };
}
