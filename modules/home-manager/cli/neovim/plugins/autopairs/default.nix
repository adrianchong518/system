{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = nvim-autopairs;
        config = ./nvim-autopairs.lua;
      })
    ];
  };
}
