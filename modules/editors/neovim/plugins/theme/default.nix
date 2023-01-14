{ config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  # config = mkIf false {
  #   hm.programs.neovim.plugins = with pkgs.vimPlugins; [
  #     (pluginWithCfg {
  #       plugin = awesome-vim-colorschemes;
  #       file = ./theme.lua;
  #     })
  #   ];
  # };
}
