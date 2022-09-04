{ config, pkgs, lib, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = awesome-vim-colorschemes;
        config = ./awesome-vim-colorschemes.lua;
      })
    ];
  };
}
