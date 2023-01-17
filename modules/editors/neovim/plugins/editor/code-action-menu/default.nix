{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
{
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim.plugins = with pkgs.vimPlugins; [
      (pluginWithCfg {
        plugin = nvim-code-action-menu;
        file = ./code-action-menu.lua;
      })
    ];
  };
}
