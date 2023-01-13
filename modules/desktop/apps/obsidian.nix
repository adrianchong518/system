{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.obsidian;
in
{
  options.modules.desktop.apps.obsidian = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf (config.modules.desktop.enable && cfg.enable) {
    packages = [ pkgs.obsidian ];
  };
}
