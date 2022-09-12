{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars));
      file = ./nvim-treesitter.lua;
    })

    (config.lib.vimUtils.pluginWithCfg {
      plugin = nvim-treesitter-context;
      file = ./nvim-treesitter-context.lua;
    })
  ];
}
