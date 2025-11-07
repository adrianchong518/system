{ flake, inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.de.hyprland;
  displayCfg = config.modules.nixos.hardware.display;

  setWallpaper = pkgs.writeShellScript "set-wallpaper" ''
    WALLPAPER_DIR="${cfg.wallpaperDir}"
    if [ -d "$WALLPAPER_DIR" ]; then
      FILE=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
      ${pkgs.swaybg}/bin/swaybg -i "$FILE" -m fill &
    fi
  '';
in
{
  options.modules.nixos.desktop.de.hyprland = with types;
    {
      enable = mkBoolOpt false;
      WLR_DRM_DEVICES = mkOpt str "";
      extraSettings = mkOpt attrs { };
      extraConfig = mkOpt lines "";

      wallpaperDir = mkOpt str "${config.files.configHome}/wallpaper";
    };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        kdePackages.polkit-kde-agent-1
        libsForQt5.qt5.qtwayland

        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum

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

    xdg.portal = {
      enable = true;
    };

    # Theming
    hm = {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        hyprcursor.enable = true;
      };
      catppuccin.cursors.enable = true;

      gtk = {
        enable = true;
        theme = {
          name = "catppuccin-mocha-mauve-standard";
          package = (pkgs.catppuccin-gtk.override {
            accents = [ config.catppuccin.accent ];
            variant = config.catppuccin.flavor;
            size = "standard";
          });
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      };
    };

    # Services
    modules.services.gpg.pinentryPackage = mkDefault pkgs.pinentry-bemenu;

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
            "${setWallpaper}"
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

    environment.sessionVariables = optionalAttrs config.modules.nixos.hardware.nvidia.enable {
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      # WLR_NO_HARDWARE_CURSORS = "1";
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

