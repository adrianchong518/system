{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.de.niri;
in
{
  options.modules.nixos.desktop.de.niri = with types; {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {
    programs.niri.enable = true;

    packages = with pkgs; [
      xwayland-satellite

      libnotify

      libqalculate
      j4-dmenu-desktop
      networkmanagerapplet
      playerctl
    ];

    modules.services.gpg.pinentryPackage = mkDefault pkgs.pinentry-bemenu;

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.swaylock = { };
    hm.services.polkit-gnome.enable = true;

    xdg.portal.enable = true;

    modules.nixos = {
      services = {
        pipewire.enable = true;
        dunst.enable = true;

        greetd = {
          enable = true;
          session = "${config.programs.niri.package}/bin/niri-session";
        };
      };

      desktop.utils = {
        wayland.enable = true;
        bemenu.enable = true;
        wlogout.enable = true;
        thunar.enable = true;
        swaybg.enable = true;
      };
    };

    files.config."niri/config.kdl".source = ./config.kdl;

    modules.nixos.desktop.utils.waybar.enable = true;
    hm.programs.waybar.settings.mainBar = {
      modules-left = mkAfter [ "niri/window" ];
      modules-center = [ "niri/workspaces" ];
    };

    environment.sessionVariables._NIRI_DISPLAY = config.modules.nixos.hardware.display.defaultDevice;
  };
}
