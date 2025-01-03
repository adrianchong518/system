{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.rofi;
  rofiPackage = if cfg.isWayland then pkgs.rofi-wayland else pkgs.rofi;
in
{
  options.modules.nixos.desktop.utils.rofi = with types; {
    enable = mkBoolOpt false;
    isWayland = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [
      libqalculate
    ];

    hm.programs.rofi = {
      enable = true;

      package = rofiPackage;

      font = "Iosevka Nerd Font 11";
      terminal = "${pkgs.wezterm}/bin/wezterm";

      plugins = with pkgs; [
        (rofi-calc.override { rofi-unwrapped = rofiPackage; })
      ];

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
        display-window = " 󰕰 Window";
        display-calc = " 󱖦 Calc";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
    };
  };
}
