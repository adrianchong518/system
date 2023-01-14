{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.term.alacritty;
in
{
  options.modules.desktop.term.alacritty = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.alacritty = {
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
  };
}
