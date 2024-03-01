{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.de.hyprland;
  displayCfg = config.modules.nixos.hardware.display;
in
{
  options.modules.nixos.desktop.de.hyprland = with types; {
    enable = mkBoolOpt false;
    WLR_DRM_DEVICES = mkOpt str "";
    extraSettings = mkOpt attrs { };
    extraConfig = mkOpt lines "";
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [
      kdePackages.polkit-kde-agent-1
      libsForQt5.qt5.qtwayland
    ];

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    hm.wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        source = [ "${./hyprland.conf}" ]
          ++ optional config.modules.nixos.services.pipewire.enable "${./pipewire.conf}";

        exec-once = [
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        ];
      } // optionalAttrs config.modules.nixos.hardware.nvidia.enable {
        env = [
          "LIBVA_DRIVER_NAME,nvidia"
          "XDG_SESSION_TYPE,wayland"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "WLR_NO_HARDWARE_CURSORS,1"
          "WLR_DRM_DEVICES,${cfg.WLR_DRM_DEVICES}"
        ];
      } // (optionalAttrs displayCfg.brightnessctl.enable {
        bind = [
          ", XF86MonBrightnessDown, exec, brightnessctl -d ${displayCfg.defaultDevice} set 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl -d ${displayCfg.defaultDevice} set 5%+"
        ];
      }) // cfg.extraSettings;

      extraConfig = mkAliasDefinitions options.modules.nixos.desktop.de.hyprland.extraConfig;
    };

    hm.programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
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

          tray = {
            icon-size = 21;
            spacing = 10;
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
            format-alt = "{time} {icon}";
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
  };
}

