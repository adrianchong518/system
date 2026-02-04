{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.services.transmission;
in
{
  options.modules.nixos.services.transmission = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;
    };

    packages = with pkgs; [
      transmission_4-qt
      # stable.stig
    ];

    my.user.extraGroups = [ "transmission" ];
  };
}
