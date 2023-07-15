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
    config = mkOpt (nullOr str) null;
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.config != null;
        message = "A neovim config must be chosen";
      }
    ];

    hm.programs.neovim = {
      enable = true;
      withNodeJs = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        fd
        ripgrep
      ];

      viAlias = cfg.enableAliases;
      vimAlias = cfg.enableAliases;
      vimdiffAlias = cfg.enableAliases;
    };

    modules.shell.aliases.v = mkIf cfg.enableAliases "nvim";
  };
}
