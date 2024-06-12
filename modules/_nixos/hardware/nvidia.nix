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
        version = "555.52.04";
        sha256_64bit = "sha256-nVOubb7zKulXhux9AruUTVBQwccFFuYGWrU1ZiakRAI=";
        sha256_aarch64 = "sha256-Kt60kTTO3mli66De2d1CAoE3wr0yUbBe7eqCIrYHcWk=";
        openSha256 = "sha256-wDimW8/rJlmwr1zQz8+b1uvxxxbOf3Bpk060lfLKuy0=";
        settingsSha256 = "sha256-PMh5efbSEq7iqEMBr2+VGQYkBG73TGUh6FuDHZhmwHk=";
        persistencedSha256 = "sha256-KAYIvPjUVilQQcD04h163MHmKcQrn2a8oaXujL2Bxro=";
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
