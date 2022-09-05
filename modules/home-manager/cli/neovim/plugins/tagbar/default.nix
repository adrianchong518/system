{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = tagbar;
        config = ./tagbar.lua;
        extraConfig = ''
          let g:tagbar_ctags_bin = '${pkgs.universal-ctags}/bin/ctags'
        '';
      })
    ];

    extraPackages = with pkgs; [
      universal-ctags
    ];
  };
}
