{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    prefix = "C-a";
    terminal = "screen-256color";
    keyMode = "vi";
    historyLimit = 5000;
    clock24 = true;
    customPaneNavigationAndResize = true;

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"

      set -g mouse on
      set -sg escape-time 0
    '';
  };
}
