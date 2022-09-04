{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = fzf-vim;
        config = ./fzf-vim.lua;
      })
    ];

    extraPackages = [
      pkgs.fzf
    ];
  };
}
