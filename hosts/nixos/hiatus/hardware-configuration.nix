{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "asus_nb_wmi" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "btrfs" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModprobeConfig = ''
    options i915 enable_dpcd_backlight=1
  '';

  hardware.enableAllFirmware = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/67cdaa3b-bd4a-43e0-a7f6-511958a3abd9";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/e0dc8c5f-acb7-4b2f-b208-7d6577b792a4";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/67cdaa3b-bd4a-43e0-a7f6-511958a3abd9";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/67cdaa3b-bd4a-43e0-a7f6-511958a3abd9";
    fsType = "btrfs";
    options = [ "subvol=nix" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/67cdaa3b-bd4a-43e0-a7f6-511958a3abd9";
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/67cdaa3b-bd4a-43e0-a7f6-511958a3abd9";
    fsType = "btrfs";
    options = [ "subvol=log" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1415-B16A";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/8cca5057-7fdb-4eee-a367-f4f96435d8a4"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
  '';

  modules.nixos.hardware = {
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    bluetooth.enable = true;
    asus.enable = true;
    thunderbolt.enable = true;
    display.brightnessctl.enable = true;
  };
}
