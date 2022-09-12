{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = telescope-nvim;
      file = ./telescope-nvim.lua;
    })

    telescope-coc-nvim
    telescope-fzf-native-nvim
    telescope-file-browser-nvim
  ];
}
