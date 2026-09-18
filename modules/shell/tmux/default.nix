{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.tmux;
in {
  options.modules.shell.tmux = with types; {
    enable = mkBoolOpt false;
    sesh.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    hm.programs.tmux = {
      enable = true;

      shortcut = "Space";
      keyMode = "vi";
      terminal = "tmux-256color";
      historyLimit = 100000;

      clock24 = true;

      mouse = true;
      aggressiveResize = true;
      focusEvents = true;
      customPaneNavigationAndResize = true;

      escapeTime = 0;

      baseIndex = 1;

      extraConfig = ''
        set -ag terminal-overrides ",*:RGB"

        set -g renumber-windows on
        set -g detach-on-destroy off

        set -g set-titles on
        set -g set-titles-string "#h: #W"

        # XXX: https://github.com/catppuccin/tmux/issues/600
        set -gF message-style "fg=#{@thm_fg},bg=#{@thm_crust},fill=#{@thm_crust}"
        set -gF message-command-style "fg=#{@thm_fg},bg=#{@thm_crust},fill=#{@thm_crust}"

        bind v   split-window -c '#{pane_current_path}' -h
        bind s   split-window -c '#{pane_current_path}'
        bind c   new-window   -c '#{pane_current_path}'
        bind C-c new-window   -c '#{pane_current_path}' -a

        bind r {
          copy-mode
          command-prompt -i -p "(search up)" \
            "send-keys -X search-backward-incremental '%%%'"
        }

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '' + optionalString cfg.sesh.enable ''
        bind -N "last-session (via sesh) " L run-shell "sesh last"
      '';

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = better-mouse-mode;
          extraConfig = ''
            set -g @scroll-without-changing-pane 'on'
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'

            resurrect_dir=~/.tmux/resurrect/
            set -g @resurrect-dir $resurrect_dir
            set -g @resurrect-hook-post-save-all "sed -i 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/nix/store/.*/bin/||g' $(readlink -f $resurrect_dir/last)"
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5'

            set -g status-interval 1
            set -g status-left ""
            set -g status-right-length 50
            set -g status-right "[#S] #H %H:%M "
          '';
        }
        open
      ];
    };

    hm.catppuccin.tmux.extraConfig = ''
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_text " #W"
    '';

    hm.programs.sesh = mkIf cfg.sesh.enable {
      enable = true;
      tmuxKey = "f";
    };

    modules.shell.fish.extraInit = /* fish */ ''
      if set -q TMUX
        alias sp="tmux splitw --"
        alias vsp="tmux splitw -h --"
      end
    '';
  };
}

