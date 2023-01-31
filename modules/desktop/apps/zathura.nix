{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.zathura;
in
{
  options.modules.desktop.apps.zathura = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.zathura.enable = true;
  };
}
