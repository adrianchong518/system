{ config, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.hardware.asus;
in
{
  options.modules.nixos.hardware.asus = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.supergfxd.enable = true;
    services.asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
