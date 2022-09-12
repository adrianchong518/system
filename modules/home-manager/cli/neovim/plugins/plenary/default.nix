{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = plenary-nvim;
      file = ./plenary-nvim.lua;
    })
  ];

  xdg.configFile."plenary-types.lua" = {
    source = ./plenary-types.lua;
    target = "nvim/data/plenary/filetypes/plenary-types.lua";
  };
}
