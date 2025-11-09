{ config, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.swaylock;
in
{
  options.modules.nixos.desktop.utils.swaylock = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { };
}
