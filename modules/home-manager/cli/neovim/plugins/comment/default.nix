{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = nvim-comment;
      file = ./nvim-comment.lua;
    })
  ];
}
