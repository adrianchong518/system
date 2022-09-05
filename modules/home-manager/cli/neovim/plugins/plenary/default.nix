{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithConfig {
      plugin = plenary-nvim;
      config = ./plenary-nvim.lua;
    })
  ];

  xdg.configFile."plenary-types.lua" = {
    source = ./plenary-types.lua;
    target = "nvim/data/plenary/filetypes/plenary-types.lua";
  };
}
