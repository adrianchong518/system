{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.hardware.wifi;
in
{
  options.modules.nixos.hardware.wifi = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    networking.wireless.iwd.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
  };
}
