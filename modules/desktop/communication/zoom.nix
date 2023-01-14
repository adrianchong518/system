{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.communication.zoom;
in
{
  options.modules.desktop.communication.zoom = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    packages = [ pkgs.zoom-us ];
  };
}
