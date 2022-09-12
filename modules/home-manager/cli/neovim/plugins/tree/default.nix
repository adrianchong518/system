{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = nvim-tree-lua;
      file = ./nvim-tree-lua.lua;
    })
  ];
}
