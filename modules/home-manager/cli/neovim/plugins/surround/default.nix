{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = nvim-surround;
      file = ./nvim-surround.lua;
    })
  ];
}
