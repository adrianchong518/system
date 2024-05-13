{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.apps.virt-manager;
in
{
  options.modules.nixos.desktop.apps.virt-manager = with types; {
    enable = mkBoolOpt false;
    gpuPCIE = mkOpt (nullOr str) null;
  };

  config = mkIf cfg.enable {
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;

      kvmgt = mkIf (cfg.gpuPCIE != null) {
        enable = true;
        device = cfg.gpuPCIE;
      };
    };

    programs.virt-manager.enable = true;

    hm.dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    my.user.extraGroups = [ "libvirtd" "kvm" ];
  };
}
