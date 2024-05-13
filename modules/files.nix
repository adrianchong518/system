{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.files;
in {
  options.files = with types; {
    home = mkOpt' attrs { } "Files to be placed in $HOME";
    config = mkOpt' attrs { } "Files to be placed in $XDG_CONFIG_HOME";
    data = mkOpt' attrs { } "Files to be placed in $XDG_DATA_HOME";

    cacheHome = mkOpt path "${config.my.user.home}/.cache";
    configHome = mkOpt path "${config.my.user.home}/.config";
    dataHome = mkOpt path "${config.my.user.home}/.local/share";
    binHome = mkOpt path "${config.my.user.home}/.local/bin";
  };

  config = {
    hm = {
      xdg = {
        enable = true;
        configFile = mkAliasDefinitions options.files.config;
        dataFile = mkAliasDefinitions options.files.data;

        cacheHome = cfg.cacheHome;
        configHome = cfg.configHome;
        dataHome = cfg.dataHome;
      };

      home.file = mkAliasDefinitions options.files.home;
    };

    env.XDG_CACHE_HOME = mkForce cfg.cacheHome;
    env.XDG_CONFIG_HOME = mkForce cfg.configHome;
    env.XDG_DATA_HOME = mkForce cfg.dataHome;
    env.XDG_BIN_HOME = mkForce cfg.binHome;

    modules.shell.extraPath = [ cfg.binHome ];
  };
}
