{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.neovim.lsp;
in
{
  options.modules.editors.neovim.lsp = with types; {
    enable = mkBoolOpt false;
    rust.enable = mkBoolOpt true;
    rnix.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    hm.programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        null-ls-nvim
        lsp-format-nvim
      ]
      ++ optional cfg.rust.enable rust-tools-nvim;

      extraConfig = readVimLuaConfigs (
        [ ./lsp-config.lua ]
        ++ optional cfg.rust.enable ./rust.lua
        ++ optional cfg.rnix.enable ./rnix.lua
      );
    };
  };
}
