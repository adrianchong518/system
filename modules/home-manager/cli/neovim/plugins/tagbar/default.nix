{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithCfg {
        plugin = tagbar;
        file = ./tagbar.lua;
      })
    ];

    extraPackages = with pkgs; [
      universal-ctags
    ];

    extraConfig = ''
      " Set up ctags for tagbar
      let g:tagbar_ctags_bin = '${pkgs.universal-ctags}/bin/ctags'
    '';
  };
}
