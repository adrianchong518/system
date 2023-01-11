{ config, pkgs, lib, ... }:

with lib;
with lib.my;
{
  config = mkIf config.modules.editors.neovim.enablePlugins {
    hm.programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        # coc
        coc-json
        coc-sumneko-lua
        coc-rust-analyzer
        coc-vimlsp
        coc-toml
      ];

      coc = {
        enable = true;
        settings = importJSON ./coc-settings.json;
      };

      extraConfig = "${readVimConfig ./coc-nvim.vim}";
    };
  };
}
