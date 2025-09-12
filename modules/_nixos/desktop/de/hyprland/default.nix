{ flake, inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.de.hyprland;
  displayCfg = config.modules.nixos.hardware.display;

  wallpaperDir = "${config.files.configHome}/wallpaper";
  cycleWallpaper = pkgs.writeShellScript "cycle-wallpaper" /* bash */ ''
    export SWWW_TRANSITION_FPS=60
    export SWWW_TRANSITION_STEP=10

    INTERVAL=900

    swww-daemon &
    sleep 0.1

    while true; do
    	find "${wallpaperDir}" -type f \
    		| while read -r img; do
            echo "$((RANDOM % 1000)):$img"
          done \
    		| sort -n | cut -d':' -f2- \
    		| while read -r img; do
          echo "$img" > /tmp/hypr/wallpaper
    			swww img "$img"
    			sleep $INTERVAL
    		done
    done
  '';

  isDischarging = pkgs.writeShellScriptBin "is-discharging" /*bash*/ ''
    battery=$(fd BAT /sys/class/power_supply/ -1)
    if [[ -n "$battery" ]]; then
      if [[ $(cat "$battery"/status) = "Discharging" ]]; then
        bash -c "$*"
      fi
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
    };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.hyprland.overlays.default
      inputs.hyprlock.overlays.default
      inputs.hypridle.overlays.default
      inputs.hyprutils.overlays.default
    ];

    environment.systemPackages = with pkgs;
      [
        kdePackages.polkit-kde-agent-1
        libsForQt5.qt5.qtwayland

        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum

        (catppuccin-gtk.override { accents = [ "mauve" ]; variant = "mocha"; size = "standard"; })

        hyprlock
        hypridle
        hyprshot
        swww

        libnotify

        cliphist
        libqalculate
        j4-dmenu-desktop
        networkmanagerapplet
        playerctl

        isDischarging
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
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "catppuccin-mocha-dark-cursors";
        size = 24;
      };

      gtk = {
        enable = true;
        theme.name = "catppuccin-mocha-mauve-standard";
      };

      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      };
    };

    files = {
      config = {
        "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
          General.theme = "catppuccin-mocha-mauve";
        };
        "Kvantum/catppuccin-mocha-mauve".source = "${pkgs.catppuccin-kvantum.override { accent = "mauve"; variant = "mocha"; }}/share/Kvantum/catppuccin-mocha-mauve";
      };
    };

    environment.variables = rec {
      HYPRCURSOR_THEME = "catppuccin-mocha-dark-cursors";
      HYPRCURSOR_SIZE = "24";
      XCURSOR_THEME = HYPRCURSOR_THEME;
      XCURSOR_SIZE = HYPRCURSOR_SIZE;
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
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.override (old: {
        libinput = pkgs.my.libinput;
      });
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    hm.wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

      settings = recursiveMerge [
        {
          source = [ "${./hyprland.conf}" ]
            ++ optional config.modules.nixos.services.pipewire.enable "${./pipewire.conf}";

          exec-once = [
            "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            "${cycleWallpaper}"
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

    hm.programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 17;
          spacing = 4;

          # mode = "hide";
          # start_hidden = true;

          modules-left = [ "clock" "tray" "taskbar" "hyprland/window" ];
          modules-center = [ "hyprland/workspaces" ];
          modules-right = [ "hyprland/submap" "custom/waybar-mpris" "idle_inhibitor" "temperature" "cpu" "memory" "network" "backlight" "wireplumber" "battery" ];

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

          tray = {
            icon-size = 21;
            spacing = 0;
            show-passive-items = true;
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
            format-muted = " muted";
            # on-click = "helvum";
            on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            on-click-right = "pavucontrol";
            on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
            on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
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

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = " ";
              deactivated = " ";
            };
          };

          temperature = {
            format = " {temperatureC}°C";
            thermal-zone = 5;
          };

          "hyprland/window" = {
            format = "{class}: {title}";
            separate-outputs = true;
          };

          "custom/waybar-mpris" =
            let
              waybar-mpris = "${pkgs.waybar-mpris.overrideAttrs (old: {
              version = "fork";
              src = inputs.waybar-mpris;
              })}/bin/waybar-mpris";
            in
            {
              return-type = "json";
              exec = "${waybar-mpris} --autofocus --play  --pause  --max-title 40";
              on-click = "${waybar-mpris} --send toggle";
              escape = true;
            };
        };
      };

      style = builtins.readFile ./waybar_style.css;
    };

    files.config."hypr/hyprlock.conf".source = ./hyprlock.conf;
    files.config."hypr/hypridle.conf".source = ./hypridle.conf;
  };
}

