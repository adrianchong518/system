{ config, pkgs, lib, ... }:

with lib;
with lib.my; {
  config = {
    hm.programs.neovim.plugins = with pkgs.vimPlugins;
      [
        (pluginWithCfg {
          plugin = gruvbox-material;
          file = ./gruvbox-material.vim;
        })
      ];
  };
}
