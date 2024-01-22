{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.wezterm;
in {
  options.modules.desktop.term.wezterm = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./config.lua;
    };
  };
}
