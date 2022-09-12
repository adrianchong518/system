{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = todo-comments-nvim;
      file = ./todo-comments-nvim.lua;
    })
  ];
}
