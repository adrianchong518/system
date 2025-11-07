{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.waybar;
in
{
  options.modules.nixos.desktop.utils.waybar = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
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

          modules-left = [ "clock" "tray" "taskbar" ];
          modules-center = [ ];
          modules-right = [ "custom/waybar-mpris" "idle_inhibitor" "temperature" "cpu" "memory" "network" ]
            ++ optional config.modules.nixos.hardware.display.brightnessctl.enable "backlight"
            ++ optional config.modules.nixos.services.pipewire.enable "wireplumber"
            ++ [ "battery" ];

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
            device = "${config.modules.nixos.hardware.display.defaultDevice}";
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
  };
}
