{ config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim.plugins = with pkgs.vimPlugins; [
      (pluginWithCfg {
        plugin = telescope-nvim;
        file = ./telescope-nvim.lua;
      })

      telescope-fzf-native-nvim
      telescope-file-browser-nvim
    ];
  };
}
