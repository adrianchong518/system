{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
{
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim.plugins = with pkgs.vimPlugins; [
      (pluginWithCfg {
        plugin = nvim-cmp;
        file = ./cmp.lua;
      })

      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-vsnip
      cmp-buffer
      cmp-path
    ];
  };
}
