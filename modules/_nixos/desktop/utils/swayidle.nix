{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.swayidle;
in
{
  options.modules.nixos.desktop.utils.swayidle = with types; {
    enable = mkBoolOpt false;
    lockTimeout = mkOpt int 300; # in seconds
    sleepTimeout = mkOpt int 600; # in seconds
  };

  config = mkIf cfg.enable {
    hm.programs.swaylock.enable = true;
    hm.catppuccin.swaylock.enable = true;
    security.pam.services.swaylock = { };

    hm.services.swayidle =
      let
        loginctl = "${pkgs.systemd}/bin/loginctl";
        systemctl = "${pkgs.systemd}/bin/systemctl";
      in
      {
        enable = true;
        package = pkgs.swayidle.override { systemdSupport = true; };

        events = {
          lock = "${pkgs.swaylock}/bin/swaylock -f";
          before-sleep = "${loginctl} lock-session";
        };

        timeouts = [
          { timeout = cfg.lockTimeout; command = "${loginctl} lock-session"; }
          { timeout = cfg.sleepTimeout; command = "${systemctl} suspend"; }
        ];
      };
  };
}
