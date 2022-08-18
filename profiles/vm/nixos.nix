{ config, pkgs, lib, ... }:

lib.mkIf config.custom.pisNixos {
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
