{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = comment-nvim;
        config = ./comment-nvim.lua;
      })
    ];
  };
}
