{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = indent-blankline-nvim;
      file = ./indent-blankline-nvim.lua;
    })
  ];
}
