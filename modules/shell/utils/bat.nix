{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils.bat;
in
{
  options.modules.shell.utils.bat = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    hm.programs.bat.enable = true;

    modules.shell.variables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p --paging always'";
    };
  };
}
