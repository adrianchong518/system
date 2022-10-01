{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    shortcut = "a";
    terminal = "screen-256color";
    keyMode = "vi";
    historyLimit = 5000;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"

      set -g mouse on
    '';
  };
}
