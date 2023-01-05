{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.browsers.firefox;
in
{
  options.modules.desktop.browsers.firefox = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.packages = with pkgs; [
      (if pkgs.stdenvNoCC.isLinux && pkgs.stdenvNoCC.isAarch64 then firefox else firefox-bin)
    ];
  };
}
