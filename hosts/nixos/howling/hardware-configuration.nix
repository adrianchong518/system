{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
  boot.supportedFilesystems = [ "btrfs" "exfat" ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;

  boot.plymouth = {
    enable = true;
    font = "${pkgs.iosevka-bin}/share/fonts/truetype/Iosevka-Regular.ttc";
  };

  # boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.asahi.peripheralFirmwareDirectory = pkgs.requireFile {
    name = "firmware";
    hashMode = "recursive";
    hash = "sha256-kjzKgwIHSqaMbNX8yQAlXCW81bz6YPLCRT3VhLOj09E=";
    message = ''
      nix-store --add-fixed --recursive sha256 /etc/nixos/firmware
    '';
  };

  boot.loader = {
    grub = {
      enable = true;
      configurationLimit = 10;
      device = "nodev";
      efiSupport = true;
    };
    efi.canTouchEfiVariables = false;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/37a61182-6423-48f1-b59e-dc0032df37eb";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EC36-0802";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [{ device = "/var/lib/swapfile"; size = 16 * 1024; }];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  networking.useDHCP = lib.mkDefault true;

  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey = "ignore";
  };

  powerManagement.enable = true;

  modules.nixos.hardware = {
    bluetooth.enable = true;
    wifi.enable = true;
    # thunderbolt.enable = true;
    display.brightnessctl.enable = true;
    display.defaultDevice = "apple-panel-bl";
  };
}
