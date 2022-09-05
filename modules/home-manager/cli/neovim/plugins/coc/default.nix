{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    coc = {
      enable = true;
      pluginConfig = config.lib.vimUtils.readConfig ./coc-nvim.vim;
      settings = lib.importJSON ./coc-settings.json;
    };

    plugins = with pkgs.vimPlugins; [
      coc-json
      coc-lua
      coc-rust-analyzer
      coc-vimlsp
      coc-toml
    ];
  };
}
