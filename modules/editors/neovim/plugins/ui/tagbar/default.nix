{ config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        (pluginWithCfg {
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
  };
}
