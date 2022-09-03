{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    theme = "Dark One Nuanced";

    settings = {
      font_family = "Iosevka Term";
      font_size = 12;

      window_padding_width = "1.0";

      term = "xterm-256color";

      enable_audio_bell = "no";

      confirm_os_window_close = 2;

      tab_bar_style = "slant";
      hide_window_decorations = "titlebar-only";

      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = "yes";
      macos_thicken_font = "0.25";
    };
  };
}
