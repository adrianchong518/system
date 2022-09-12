{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = lazygit-nvim;
      file = ./lazygit-nvim.lua;
    })
  ];
}
