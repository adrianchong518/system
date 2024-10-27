{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.utils;
in
{
  options.modules.desktop.utils = with types; {
    feh.enable = mkBoolOpt false;
    imv.enable = mkBoolOpt false;
    mpv.enable = mkBoolOpt false;
  };

  config = {
    packages = with pkgs; ([ ]
      ++ optional cfg.feh.enable feh
      ++ optional cfg.imv.enable imv
      ++ optional cfg.mpv.enable mpv
    );
  };
}
