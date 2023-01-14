{ config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  # config = mkIf false {
  #   hm.programs.neovim.plugins = with pkgs.vimPlugins; [
  #     (pluginWithCfg {
  #       plugin = srcery-vim;
  #       file = ./srcery.vim;
  #     })
  #   ];
  # };
}
