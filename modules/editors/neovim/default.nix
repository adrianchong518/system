{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.neovim;
in
{
  options.modules.editors.neovim = with types; {
    enable = mkBoolOpt false;
    enableAliases = mkBoolOpt true;
    enablePlugins = mkBoolOpt false;
  };

  config = mkIf cfg.enable
    ({
      hm.programs.neovim = {
        enable = true;

        extraConfig = ''
          ${readVimConfig ./setting.lua}
          ${readVimConfig ./keymap.lua}
        '';
      };
    }
    // mkIf cfg.enableAliases {
      hm.programs.neovim = {
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };

      modules.shell.aliases.v = "nvim";
    });
}
