{ config, pkgs, lib, ... }:

{
  programs.neovim.plugins = with pkgs.stable.vimPlugins; [
    (config.lib.vimUtils.pluginWithCfg {
      plugin = (nvim-treesitter.withPlugins (_: pkgs.stable.tree-sitter.allGrammars));
      file = ./nvim-treesitter.lua;
    })

    (config.lib.vimUtils.pluginWithCfg {
      plugin = nvim-treesitter-context;
      file = ./nvim-treesitter-context.lua;
    })
  ];
}
