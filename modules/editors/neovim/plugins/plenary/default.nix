{ config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim.plugins = with pkgs.vimPlugins; [
      (pluginWithCfg {
        plugin = plenary-nvim;
        file = ./plenary-nvim.lua;
      })
    ];

    files.config."plenary-types.lua" = {
      source = ./plenary-types.lua;
      target = "nvim/data/plenary/filetypes/plenary-types.lua";
    };
  };
}
