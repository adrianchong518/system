{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = nvim-tree-lua;
        config = ./nvim-tree-lua.lua;
      })
    ];
  };
}
