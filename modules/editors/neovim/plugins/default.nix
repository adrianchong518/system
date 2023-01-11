{ config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  # TODO: set up better plugin system
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim.plugins = with pkgs.vimPlugins; [
      nvim-web-devicons

      # Editor Features
      vim-lion

      # Language / LSP
      vim-nix
    ];
  };
}
