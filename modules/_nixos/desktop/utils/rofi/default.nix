{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.rofi;
in
{
  options.modules.nixos.desktop.utils.rofi = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.rofi = {
      enable = true;
      font = "Iosevka Nerd Font 13";
      terminal = "${pkgs.wezterm}/bin/wezterm";
      plugins = with pkgs; [ rofi-calc ];
      theme = ./catppuccin-mocha.rasi;
      extraConfig = {
        modi = "run,drun,window,calc";
        icon-theme = "Oranchelo";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " 﩯 Window";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
    };
  };
}
