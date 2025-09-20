{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.services.dunst;
in
{
  options.modules.nixos.services.dunst = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.services.dunst = {
      enable = true;
      iconTheme = {
        package = pkgs.paper-icon-theme;
        name = "Paper";
      };
      settings = {
        global = {
          font = "Iosevka Nerd Font 11";

          frame_color = "#89b4fa";
          separator_color = "frame";
          highlight = "#89b4fa";
        };

        urgency_low = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };

        urgency_normal = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };

        urgency_critical = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          frame_color = "#fab387";
        };
      };
    };
  };
}
