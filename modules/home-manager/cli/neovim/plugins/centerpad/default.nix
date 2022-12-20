{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = centerpad-nvim;
      file = ./centerpad.lua;
    })
  ];
}
