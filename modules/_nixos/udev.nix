{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.udev;
in
{
  options.modules.nixos.udev = with types; {
    openocd.enable = mkBoolOpt false;
  };

  config = mkIf cfg.openocd.enable {
    users.extraGroups.plugdev = { };
    user.extraGroups = [ "plugdev" "dialout" ];
    services.udev.packages = [ pkgs.openocd ];
  };
}
