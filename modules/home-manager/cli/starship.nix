{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      add_newline = false;
      line_break.disabled = true;

      # directory.fish_style_pwd_dir_length = 1;
      status.disabled = false;
    };
  };
}
