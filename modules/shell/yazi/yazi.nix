{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.shell.yazi;
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "540f4ea6d475c81cba8dac252932768fbd2cfd86";
    hash = "sha256-IRv75b3SR11WfLqGvQZhmBo1BuR5zsbZxfZIKDVpt9k=";
  };
in
{
  options.modules.shell.yazi = with types; { enable = mkBoolOpt false; };
  config = mkIf cfg.enable {
    hm.programs.yazi = {
      enable = true;
      shellWrapperName = "y";

      theme = { flavor = { use = "catppuccin-mocha"; }; };
      flavors = { catppuccin-mocha = ./catppuccin-mocha.yazi; };

      plugins = {
        chmod = "${yazi-plugins}/chmod.yazi";
        full-border = "${yazi-plugins}/full-border.yazi";
        max-preview = "${yazi-plugins}/max-preview.yazi";
        git = "${yazi-plugins}/git.yazi";
        starship = pkgs.fetchFromGitHub {
          owner = "Rolv-Apneseth";
          repo = "starship.yazi";
          rev = "247f49da1c408235202848c0897289ed51b69343";
          sha256 = "sha256-0J6hxcdDX9b63adVlNVWysRR5htwAtP5WhIJ2AK2+Gs=";
        };
      };

      settings = {
        plugin.prepend_fetchers = [
          { id = "git"; name = "*"; run = "git"; }
          { id = "git"; name = "*/"; run = "git"; }
        ];
        manager = {
          show_hidden = true;
        };
        preview = {
          max_width = 1000;
          max_height = 1000;
        };
      };

      keymap = {
        manager.prepend_keymap = [
          {
            on = "T";
            run = "plugin --sync max-preview";
            desc = "Maximize or restore the preview pane";
          }
          {
            on = [ "c" "m" ];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
        ];
      };

      initLua = ''
        require("full-border"):setup()
        require("git"):setup()
        require("starship"):setup()
      '';
    };
  };
}
