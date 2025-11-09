{ flake, inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.de.hyprland;
  displayCfg = config.modules.nixos.hardware.display;
in
{
  options.modules.nixos.desktop.de.hyprland = with types;
    {
      enable = mkBoolOpt false;
      WLR_DRM_DEVICES = mkOpt str "";
      extraSettings = mkOpt attrs { };
      extraConfig = mkOpt lines "";
    };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        kdePackages.polkit-kde-agent-1

        hyprlock
        hypridle
        hyprshot

        libnotify

        cliphist
        libqalculate
        j4-dmenu-desktop
        networkmanagerapplet
        playerctl
      ];

    security.polkit.enable = true;
    security.pam.services.hyprlock = { };

    xdg.portal.enable = true;
    xdg.portal.wlr.enable = true;

    # Services
    modules.services.gpg.pinentryPackage = mkDefault pkgs.pinentry-bemenu;

    hm.wayland.systemd.target = "hyprland-session.target";

    modules.nixos = {
      services = {
        pipewire.enable = true;
        dunst.enable = true;

        greetd = {
          enable = true;
          session = "${config.programs.hyprland.package}/bin/Hyprland";
        };
      };

      desktop.utils = {
        wayland.enable = true;
        # rofi = { enable = true; isWayland = true; };
        bemenu.enable = true;
        wlogout.enable = true;
        thunar.enable = true;
        swaybg.enable = true;
      };
    };

    programs.xfconf.enable = true;

    programs.hyprland = {
      enable = true;
      # package = pkgs.hyprland.override (old: {
      #   # libinput = pkgs.my.libinput;
      # });
    };

    hm.wayland.windowManager.hyprland = {
      enable = true;

      settings = recursiveMerge [
        {
          source = [ "${./hyprland.conf}" ]
            ++ optional config.modules.nixos.services.pipewire.enable "${./pipewire.conf}";

          exec-once = [
            "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            "swaybg-set-wallpaper"
            "nm-applet"
          ];
        }
        (optionalAttrs displayCfg.brightnessctl.enable {
          bindle = [
            ", XF86MonBrightnessDown, exec, brightnessctl -d ${displayCfg.defaultDevice} set 5%-"
            ", XF86MonBrightnessUp, exec, brightnessctl -d ${displayCfg.defaultDevice} set 5%+"
          ];
        })
        cfg.extraSettings
      ];

      extraConfig = mkAliasDefinitions options.modules.nixos.desktop.de.hyprland.extraConfig;
    };

    modules.nixos.desktop.utils.waybar.enable = true;
    hm.programs.waybar.settings.mainBar = {
      modules-left = mkAfter [ "hyprland/window" ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = mkBefore [ "hyprland/submap" ];

      "hyprland/window" = {
        format = "{class}: {title}";
        separate-outputs = true;
      };

      "hyprland/submap" = {
        format = "Mode: {}";
      };
    };

    files.config."hypr/hyprlock.conf".source = ./hyprlock.conf;
    files.config."hypr/hypridle.conf".source = ./hypridle.conf;
  };
}

