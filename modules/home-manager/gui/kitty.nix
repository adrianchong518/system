{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    theme = "Ayu";

    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 13;
      adjust_line_height = "120%";

      window_padding_width = "1.0";

      term = "xterm-256color";
      shell_integration = "no-cursor";

      enable_audio_bell = "no";

      confirm_os_window_close = 2;

      tab_bar_style = "slant";
      hide_window_decorations = "titlebar-only";

      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = "yes";
    };
  };

  programs.fish.interactiveShellInit = ''
    if set -q KITTY_INSTALLATION_DIR
      source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
      set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end
  '';
}
