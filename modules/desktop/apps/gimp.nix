{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.gimp;
in
{
  options.modules.desktop.apps.gimp = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf (config.modules.desktop.enable && cfg.enable) {
    packages = [ pkgs.gimp ];
  };
}
