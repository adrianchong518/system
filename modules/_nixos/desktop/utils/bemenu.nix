{ lib, config, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.bemenu;
in
{
  options.modules.nixos.desktop.utils.bemenu = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.variables.BEMENU_OPTS = config.home-manager.users.${config.my.user.name}.home.sessionVariables.BEMENU_OPTS;

    hm.programs.bemenu = {
      enable = true;
      settings = {
        ignorecase = true;
        wrap = true;

        line-height = 13;
        fn = "Iosevka";
        bottom = true;
        hp = 10;

        binding = "vim";
        vim-esc-exits = true;

        fb = "#1e1e2e";
        ff = "#cdd6f4";
        nb = "#1e1e2e";
        nf = "#cdd6f4";
        tb = "#1e1e2e";
        hb = "#1e1e2e";
        tf = "#f38ba8";
        hf = "#f9e2af";
        af = "#cdd6f4";
        ab = "#1e1e2e";
      };
    };
  };
}
