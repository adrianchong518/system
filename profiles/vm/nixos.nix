{ config, pkgs, lib, ... }:

{
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
