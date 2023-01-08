{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
{
  options.files = with types; {
    home = mkOpt' attrs { } "Files to be placed in $HOME";
    config = mkOpt' attrs { } "Files to be placed in $XDG_CONFIG_HOME";
    data = mkOpt' attrs { } "Files to be placed in $XDG_DATA_HOME";
  };

  config = {
    hm = {
      xdg = {
        enable = true;
        configFile = mkAliasDefinitions options.files.config;
        dataFile = mkAliasDefinitions options.files.data;
      };

      home.file = mkAliasDefinitions options.files.home;
    };

    env.XDG_CACHE_HOME = mkForce "$HOME/.cache";
    env.XDG_CONFIG_HOME = mkForce "$HOME/.config";
    env.XDG_DATA_HOME = mkForce "$HOME/.local/share";
    env.XDG_BIN_HOME = mkForce "$HOME/.local/bin";
  };
}
