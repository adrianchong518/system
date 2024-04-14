{ flake, inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.de.hyprland;
  displayCfg = config.modules.nixos.hardware.display;

  wallpaperDir = "${flake}/wallpapers";
  cycleWallpaper = pkgs.writeShellScript "cycle-wallpaper" /* bash */ ''
    export SWWW_TRANSITION_FPS=60
    export SWWW_TRANSITION_STEP=10

    INTERVAL=900

    swww init
    sleep 0.1

    while true; do
    	find "${wallpaperDir}" -type f \
    		| while read -r img; do
            echo "$((RANDOM % 1000)):$img"
          done \
    		| sort -n | cut -d':' -f2- \
    		| while read -r img; do
    			swww img "$img"
    			sleep $INTERVAL
    		done
    done
  '';
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
    nixpkgs.overlays = [
      inputs.hyprland.overlays.default
      inputs.hyprlock.overlays.default
      inputs.hypridle.overlays.default
    ];

    environment.systemPackages = with pkgs;
      [
        kdePackages.polkit-kde-agent-1
        libsForQt5.qt5.qtwayland

        qt5ct
        libsForQt5.qtstyleplugin-kvantum

        hyprlock
        hypridle
        hyprshot
        swww

        libnotify

        cliphist
      ];

    security.polkit.enable = true;
    security.pam.services.hyprlock = { };

    # Theming
    hm = {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "Catppuccin-Mocha-Dark-Cursors";
        size = 20;
      };

      qt = {
        enable = true;
        platformTheme = "qtct";
        style.name = "kvantum";
      };
    };

    files = {
      config = {
        "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
          General.theme = "Catppuccin-Mocha-Mauve";
        };
        "Kvantum/Catppuccin-Mocha-Mauve".source = "${pkgs.catppuccin-kvantum.override { accent = "Mauve"; variant = "Mocha"; }}/share/Kvantum/Catppuccin-Mocha-Mauve";
      };
    };

    environment.variables = {
      XCURSOR_THEME = "Catppuccin-Mocha-Dark-Cursors";
      XCURSOR_SIZE = "20";
    };

    # Services
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
        rofi = { enable = true; isWayland = true; };
        wlogout.enable = true;
        thunar.enable = true;
      };
    };

    programs.hyprland = {
      enable = true;
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
            "${cycleWallpaper}"
          ];
        }
        (optionalAttrs displayCfg.brightnessctl.enable {
          bind = [
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
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    hm.programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 17;
          spacing = 4;

          modules-left = [ "clock" ];
          modules-center = [ "hyprland/workspaces" ];
          modules-right = [ "hyprland/submap" "cpu" "memory" "network" "backlight" "wireplumber" "battery" ];

          clock = {
            format = "{:%H:%M | %A %d %b %Y}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              on-scroll = 1;
              format = {
                months = "<span color='#FFFFFF'><b>{}</b></span>";
                days = "<span color='#DCDCDC'><b>{}</b></span>";
                weeks = "<span color='#FFFFFF'><b>W{}</b></span>";
                weekdays = "<span color='#FFFFFF'><b>{}</b></span>";
                today = "<span color='#FFFFFF'><b>{}</b></span>";
              };
            };
          };

          "hyprland/submap" = {
            format = "Mode: {}";
          };

          network = {
            interval = 30;
            format = "{ifname}";
            format-ethernet = "{icon} {ipaddr}";
            format-wifi = "{icon} {signalStrength}%";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "{icon}";
            format-icons = {
              ethernet = "󰈀";
              wifi = "󰖩";
              disconnected = "󰖪";
            };
            tooltip = true;
            tooltip-format = " {essid} at {ifname} via {gwaddr}";
          };

          backlight = {
            device = "${displayCfg.defaultDevice}";
            format = "{icon} {percent}%";
            format-icons = [ "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨" ];
            tooltip = false;
          };

          battery = {
            interval = 5;
            states = {
              good = 95;
              warning = 35;
              critical = 20;
            };
            format = "{icon} {capacity}%";
            format-warning = "{icon} {capacity}%";
            format-critical = "{icon} {capacity}%";
            format-time = "{H} h {M} min";
            format-charging = "{icon} {capacity}%";
            format-plugged = "{icon} {capacity}%";
            format-alt = "{icon} {time}";
            format-icons = {
              charging = "󰃨";
              plugged = "";
              default = [ "" "" "" "" "" ];
            };
          };

          wireplumber = {
            format = "{icon} {volume}%";
            format-muted = "";
            # on-click = "helvum";
            format-icons = [ "" "" "" ];
          };

          cpu = {
            format = " {icon} {usage}%";
            format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          };

          memory = {
            format = " {percentage}%";
            tooltip-format = "{used:0.1f}GiB ({swapUsed:0.1f}GiB swap)";
          };
        };
      };

      style = builtins.readFile ./waybar_style.css;
    };

    files.config."hypr/hyprlock.conf".source = ./hyprlock.conf;
    files.config."hypr/hypridle.conf".source = ./hypridle.conf;
  };
}

