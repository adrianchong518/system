{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.desktop.utils;
in
{
  options.modules.darwin.desktop.utils = with types; {
    enable = mkBoolOpt false;

    # brew casks
    aldente.enable = mkBoolOpt false; # NOTE: Disabled by default
    appCleaner.enable = mkBoolOpt cfg.enable;
    hot.enable = mkBoolOpt cfg.enable;
    iina.enable = mkBoolOpt false; # NOTE: Disabled by default
    monitorControl.enable = mkBoolOpt cfg.enable;
    mos.enable = mkBoolOpt cfg.enable;
    stats.enable = mkBoolOpt cfg.enable;
    theUnarchiver.enable = mkBoolOpt cfg.enable;
    transmission.enable = mkBoolOpt cfg.enable; # TODO: Investigate linux version / alternative

    # mas apps
    amphetamine.enable = mkBoolOpt cfg.enable;
    easyRes.enable = mkBoolOpt cfg.enable;
    handMirror.enable = mkBoolOpt false; # NOTE: Disabled by default
  };

  config = {
    homebrew = {
      casks = (
        [ ]
        ++ optional cfg.aldente.enable "aldente"
        ++ optional cfg.appCleaner.enable "appCleaner"
        ++ optional cfg.hot.enable "hot"
        ++ optional cfg.iina.enable "iina"
        ++ optional cfg.monitorControl.enable "monitorcontrol"
        ++ optional cfg.mos.enable "mos"
        ++ optional cfg.stats.enable "stats"
        ++ optional cfg.theUnarchiver.enable "the-unarchiver"
        ++ optional cfg.transmission.enable "transmission"
      );

      masApps = (
        { }
        // optionalAttrs cfg.amphetamine.enable { Amphetamine = 937984704; }
        // optionalAttrs cfg.easyRes.enable { EasyRes = 688211836; }
        // optionalAttrs cfg.handMirror.enable { HandMirror = 1502839586; }
      );
    };
  };
}
