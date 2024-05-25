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
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "555.42.02";
        sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
        sha256_aarch64 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
        openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
        settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
        persistencedSha256 = fakeSha256;
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
