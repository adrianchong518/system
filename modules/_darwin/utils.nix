{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.utils;
in
{
  options.modules.darwin.utils = with types; {
    enable = mkBoolOpt false;

    # brew casks
    aldente.enable = mkBoolOpt false; # NOTE: Disabled by default
    appCleaner.enable = mkBoolOpt true;
    hot.enable = mkBoolOpt true;
    iina.enable = mkBoolOpt false; # NOTE: Disabled by default
    monitorControl.enable = mkBoolOpt true;
    mos.enable = mkBoolOpt true;
    stats.enable = mkBoolOpt true;
    theUnarchiver.enable = mkBoolOpt true;
    transmission.enable = mkBoolOpt true; # TODO: Investigate linux version / alternative

    # mas apps
    amphetamine.enable = mkBoolOpt true;
    easyRes.enable = mkBoolOpt true;
    handMirror.enable = mkBoolOpt false; # NOTE: Disabled by default
  };

  config = mkIf (config.modules.desktop.enable && config.modules.darwin.homebrew.enable && cfg.enable) {
    homebrew = {
      casks = [ ]
        ++ optional cfg.aldente.enable "aldente"
        ++ optional cfg.appCleaner.enable "appCleaner"
        ++ optional cfg.hot.enable "hot"
        ++ optional cfg.iina.enable "iina"
        ++ optional cfg.monitorControl.enable "monitorcontrol"
        ++ optional cfg.mos.enable "mos"
        ++ optional cfg.stats.enable "stats"
        ++ optional cfg.theUnarchiver.enable "the-unarchiver"
        ++ optional cfg.transmission.enable "transmission"
      ;

      masApps = { }
        // optionalAttrs cfg.amphetamine.enable { Amphetamine = 937984704; }
        // optionalAttrs cfg.easyRes.enable { EasyRes = 688211836; }
        // optionalAttrs cfg.handMirror.enable { HandMirror = 1502839586; }
      ;
    };
  };
}
