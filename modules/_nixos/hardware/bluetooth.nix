{ config, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.hardware.bluetooth;
in
{
  options.modules.nixos.hardware.bluetooth = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
