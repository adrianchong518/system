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
        set -g terminal-overrides ',xterm*:Tc'
        set -g mouse              on
        set -g renumber-windows   on

        set -g status-interval    2
        set -g status-left-length 200
        set -g status-position    top

        bind '%' split-window -c '#{pane_current_path}' -h
        bind '"' split-window -c '#{pane_current_path}'
        bind c   new-window   -c '#{pane_current_path}'

        bind C-l send-keys C-l

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
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
        {
          plugin = vim-tmux-navigator;
        }
        {
          plugin = catppuccin;
          extraConfig = ''
          '';
        }
      ];
    };

    packages = with pkgs; [
      gitmux
    ];
  };
}

