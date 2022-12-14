{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = vim-illuminate;
      file = ./vim-illuminate.lua;
    })
  ];
}
