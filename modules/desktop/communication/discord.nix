{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.communication.discord;
in
{
  options.modules.desktop.communication.discord = with types; {
    enable = mkBoolOpt true;
  };

  config = mkIf (config.modules.desktop.enable && cfg.enable) {
    packages = [ pkgs.discord ];
  };
}
