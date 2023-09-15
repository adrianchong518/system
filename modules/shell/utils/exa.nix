{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils.eza;
in
{
  options.modules.shell.utils.eza = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
    lsAlias = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    hm.programs.eza.enable = true;

    modules.shell.aliases = mkIf cfg.lsAlias (
      let
        lsBase = "${pkgs.eza}/bin/eza --group-directories-first --color=always --icons --git";
      in
      rec {
        l = "${lsBase} -l";
        ls = "${l}";
        la = "${lsBase} -la";
        t = "${lsBase} -T";
        lt = "${lsBase} -lT";
        ta = "${lsBase} -aT";
        lta = "${lsBase} -laT";
      }
    );
  };
}
