{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      import = [
        ./gruvbox-material.yml
      ];

      window = {
        dynamic_padding = true;
        decorations = "none";
      };

      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 13;
      };
    };
  };
}
