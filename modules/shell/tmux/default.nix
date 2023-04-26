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

      shortcut = "Space";
      terminal = "screen-256color";
      keyMode = "vi";
      historyLimit = 1000000;
      clock24 = true;
      customPaneNavigationAndResize = true;
      escapeTime = 0;

      extraConfig = ''
        set -g terminal-overrides ',*256col*:Tc'
        set -g mouse              on
        set -g renumber-windows   on

        set -g status-interval    2
        set -g status-left-length 200
        set -g status-position    top

        set -g status-left  '#[fg=blue,bold]#S#[fg=white,nobold]#(${pkgs.gitmux}/bin/gitmux -timeout 200ms -cfg ${./gitmux.yml} "#{pane_current_path}") '
        set -g status-right ' '

        set -g pane-active-border-style     'fg=magenta,bg=default'
        set -g pane-border-style            'fg=brightblack,bg=default'
        set -g status-style                 'bg=default'
        set -g window-status-current-format '#[fg=magenta]#W'
        set -g window-status-format         '#[fg=gray]#W'

        bind '%' split-window -c '#{pane_current_path}' -h
        bind '"' split-window -c '#{pane_current_path}'
        bind c   new-window   -c '#{pane_current_path}'
      '';

      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        {
          plugin = better-mouse-mode;
          extraConfig = ''
            set -g @scroll-without-changing-pane 'on'
            set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'
          '';
        }
        {
          plugin = fzf-tmux-url;
          extraConfig = ''
            set -g @fzf-url-fzf-options '-w 50% -h 50% --prompt="   " --border-label=" Open URL " --no-preview'
            set -g @fzf-url-history-limit 2000
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
          '';
        }
        {
          plugin = tmux-fzf;
          extraConfig = ''
            TMUX_FZF_LAUNCH_KEY="C-Space"
            TMUX_FZF_OPTIONS="-p -w 62% -h 38% -m"
            TMUX_FZF_PREVIEW=0

            bind a run-shell -b "${tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh attach"
          '';
        }
      ];
    };

    packages = with pkgs; [
      gitmux
    ];
  };
}

