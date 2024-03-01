{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.de.plasma6;
in
{
  options.modules.nixos.desktop.de.plasma6 = {
    enable = mkBoolOpt false;
    sddm.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = cfg.sddm.enable;
      desktopManager.plasma6.enable = true;
    };
  };
}
