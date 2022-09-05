{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = telescope-nvim;
        config = ./telescope-nvim.lua;
      })
      telescope-fzf-native-nvim
      telescope-coc-nvim
    ];
  };
}
