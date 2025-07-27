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

    hardware.nvidia-container-toolkit.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;

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
