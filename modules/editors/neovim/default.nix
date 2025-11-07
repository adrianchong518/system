{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.neovim;
in {
  options.modules.editors.neovim = with types; {
    enable = mkBoolOpt false;
    enableAliases = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    packages = [ pkgs.my.neovim ];
    modules.shell.aliases = mkIf cfg.enableAliases {
      v = "nvim";
      gg = "nvim -c 'Neogit kind=replace'";
    };
    hm.catppuccin.nvim.enable = false;
  };
}
