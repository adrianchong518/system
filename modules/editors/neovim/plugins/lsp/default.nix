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
  };

  config = mkIf cfg.enable {
    hm.programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
      ]
      ++ optional cfg.rust.enable rust-tools-nvim;

      extraConfig = ''
        ${readVimConfig ./lsp-config.lua}
        ${optionalString cfg.rust.enable (readVimConfig ./rust.lua)}
      '';
    };
  };
}
