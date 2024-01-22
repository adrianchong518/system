{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.neovim;
in {
  options.modules.editors.neovim = with types; {
    enable = mkBoolOpt false;
    enableAliases = mkBoolOpt true;
    enablePlugins = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.neovim = {
      enable = true;

      viAlias = cfg.enableAliases;
      vimAlias = cfg.enableAliases;
      vimdiffAlias = cfg.enableAliases;

      extraConfig = ''
        ${readVimConfig ./setting.lua}
        ${readVimConfig ./keymap.lua}
      '';
    };

    modules.shell.aliases.v = mkIf cfg.enableAliases "nvim";
  };
}
