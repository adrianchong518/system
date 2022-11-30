{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.tmux;
in
{
  options.modules.shell.tmux = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.tmux = {
      enable = true;

      shortcut = "a";
      terminal = "screen-256color";
      keyMode = "vi";
      historyLimit = 10000;
      clock24 = true;
      customPaneNavigationAndResize = true;
      escapeTime = 0;

      extraConfig = ''
        set -ga terminal-overrides ",*256col*:Tc"

        set -g mouse on
      '';
    };
  };
}
