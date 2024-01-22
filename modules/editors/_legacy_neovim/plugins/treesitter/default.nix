{ config, pkgs, lib, ... }:

with lib;
with lib.my; {
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim.plugins = with pkgs.stable.vimPlugins; [
      (pluginWithCfg {
        plugin = (nvim-treesitter.withPlugins
          (_: pkgs.stable.tree-sitter.allGrammars));
        file = ./nvim-treesitter.lua;
      })

      (pluginWithCfg {
        plugin = nvim-treesitter-context;
        file = ./nvim-treesitter-context.lua;
      })
    ];
  };
}
