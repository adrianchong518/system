{ config, pkgs, lib, ... }: {
  home.packages = [ pkgs.tree-sitter ];
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (config.lib.vimUtils.pluginWithConfig {
        plugin = (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars));
        config = ./nvim-treesitter.lua;
      })
      (config.lib.vimUtils.pluginWithConfig {
        plugin = nvim-treesitter-context;
        config = ./nvim-treesitter-context.lua;
      })
    ];
  };
}
