{ config, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.hardware.thunderbolt;
in
{
  options.modules.nixos.hardware.thunderbolt = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.hardware.bolt.enable = true;
  };
}
