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
      historyLimit = 1000000;
      clock24 = true;
      customPaneNavigationAndResize = true;
      escapeTime = 0;

      extraConfig = ''
        set -ga terminal-overrides ",*256col*:Tc"
        set -g mouse on
        set -g renumber-windows on

        set -g status-interval 2
        set -g status-left-length 200
        set -g status-position top

        set -g status-left "#[fg=blue,bold]#S#[fg=white,nobold]#(${pkgs.gitmux}/bin/gitmux -timeout 200ms -cfg ${./gitmux.yml} \"#{pane_current_path}\") "
        set -g status-right ""

        set -g pane-active-border-style     "fg=magenta,bg=default"
        set -g pane-border-style            "fg=brightblack,bg=default"
        set -g status-style                 "bg=default"
        set -g window-status-current-format "#[fg=magenta]#W"
        set -g window-status-format         "#[fg=gray]#W"

        bind '%' split-window -c '#{pane_current_path}' -h
        bind '"' split-window -c '#{pane_current_path}'
        bind c   new-window   -c '#{pane_current_path}'
      '';

      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        {
          plugin = better-mouse-mode;
          extraConfig = ''
            set -g @scroll-without-changing-pane "on"
            set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"
          '';
        }
        {
          plugin = fzf-tmux-url;
          extraConfig = ''
            set -g @fzf-url-fzf-options '-w 50% -h 50% --prompt="   " --border-label=" Open URL " --no-preview'
            set -g @fzf-url-history-limit 2000
          '';
        }
      ];
    };

    packages = with pkgs; [
      gitmux
    ];
  };
}

