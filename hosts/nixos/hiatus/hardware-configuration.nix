{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "asus_nb_wmi" "cpufreq_stats" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
  boot.supportedFilesystems = [ "btrfs" "exfat" ];
  boot.kernelParams = [
    "selinux=0"
    "resume_offset=178464000"
    "quiet"
    "intremap=on"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
  ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;

  boot.plymouth = {
    enable = true;
    font = "${pkgs.iosevka-bin}/share/fonts/truetype/Iosevka-Regular.ttc";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.extraModprobeConfig = ''
    options i915 enable_dpcd_backlight=1
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    options nvidia_drm modeset=1 fbdev=1
  '';

  hardware.enableAllFirmware = true;

  boot.loader = {
    grub = {
      enable = true;
      configurationLimit = 10;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
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

  boot.resumeDevice = "/dev/dm-0";

  swapDevices = [{ device = "/var/lib/swapfile"; size = 32 * 1024; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey = "ignore";
  };

  powerManagement.enable = true;

  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      # From https://github.com/lihe07/linux-on-zephyrus
      CPU_BOOST_ON_AC = "1";
      CPU_BOOST_ON_BAT = "0";
      INTEL_GPU_BOOST_FREQ_ON_AC = "1";
      INTEL_GPU_BOOST_FREQ_ON_BAT = "0";
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      PLATFORM_PROFILE_ON_BAT = "quiet";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };

  modules.nixos.hardware = {
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    intelGraphics.enable = true;
    bluetooth.enable = true;
    asus.enable = true;
    thunderbolt.enable = true;
    display.brightnessctl.enable = true;
  };
}
