{ config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim.plugins = with pkgs.vimPlugins; [
      (pluginWithCfg {
        plugin = fidget-nvim;
        file = ./fidget.lua;
      })
    ];
  };
}
