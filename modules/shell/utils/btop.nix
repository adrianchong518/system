{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.utils.btop;
in {
  options.modules.shell.utils.btop = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    hm.programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;

        proc_gradient = false;
      };
    };
  };
}
