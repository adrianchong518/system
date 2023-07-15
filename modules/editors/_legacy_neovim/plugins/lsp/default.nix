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
    nix.enable = mkBoolOpt true;
    lua.enable = mkBoolOpt true;
    fennel.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.editors.neovim.enablePlugins;
        message = "Neovim plugins must be enabled to enable lsp support";
      }
    ];

    hm.programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        null-ls-nvim
        lsp-format-nvim
        lsp-inlayhints-nvim
      ]
      ++ optional cfg.rust.enable rust-tools-nvim;

      extraConfig = readVimLuaConfigs (
        [ ./lsp-config.lua ]
        ++ optional cfg.rust.enable ./rust.lua
        ++ optional cfg.nix.enable ./nix.lua
        ++ optional cfg.lua.enable ./lua.lua
        ++ optional cfg.fennel.enable ./fennel.lua
      );
    };
  };
}
