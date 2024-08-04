{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.services.pipewire;
in
{
  options.modules.nixos.services.pipewire = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };

    packages = with pkgs; [
      helvum
      pavucontrol
    ];
  };
}
