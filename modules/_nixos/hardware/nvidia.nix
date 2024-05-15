{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.hardware.nvidia;
in
{
  options.modules.nixos.hardware.nvidia = with types; {
    enable = mkBoolOpt false;
    prime = {
      enable = mkBoolOpt false;
      sync = mkBoolOpt false;
      intelBusId = mkOpt str "";
      nvidiaBusId = mkOpt str "";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package =
        let
          rcu_patch = pkgs.fetchpatch {
            url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
            hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
          };
        in
        config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "550.40.07";
          sha256_64bit = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
          sha256_aarch64 = "sha256-AV7KgRXYaQGBFl7zuRcfnTGr8rS5n13nGUIe3mJTXb4=";
          openSha256 = "sha256-mRUTEWVsbjq+psVe+kAT6MjyZuLkG2yRDxCMvDJRL1I=";
          settingsSha256 = "sha256-c30AQa4g4a1EHmaEu1yc05oqY01y+IusbBuq+P6rMCs=";
          persistencedSha256 = "sha256-11tLSY8uUIl4X/roNnxf5yS2PQvHvoNjnd2CB67e870=";
          patches = [ rcu_patch ];
        };

      prime = mkIf cfg.prime.enable ({
        intelBusId = cfg.prime.intelBusId;
        nvidiaBusId = cfg.prime.nvidiaBusId;
      } // (if cfg.prime.sync then {
        sync.enable = true;
      } else {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      }));
    };
  };
}
