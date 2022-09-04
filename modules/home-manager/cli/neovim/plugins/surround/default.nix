{ config, pkgs, lib, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # new neovim stuff
      (config.lib.vimUtils.pluginWithConfig {
        plugin = nvim-surround;
        config = ./nvim-surround.lua;
      })
    ];
  };
}
