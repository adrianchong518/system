{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = lualine-nvim;
        config = ./lualine-nvim.lua;
      })
    ];
  };
}
