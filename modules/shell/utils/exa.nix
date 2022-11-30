{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils.exa;
in
{
  options.modules.shell.utils.exa = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
    lsAlias = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    hm.programs.exa.enable = true;

    modules.shell.aliases = mkIf cfg.lsAlias (
      let
        lsBase = "${pkgs.exa}/bin/exa --group-directories-first --color=always --icons --git";
        treeBase = "${lsBase} --git-ignore";
      in
      rec {
        l = "${lsBase} -l";
        ls = "${l}";
        la = "${lsBase} -la";
        t = "${treeBase} -T";
        lt = "${treeBase} -lT";
        ta = "${treeBase} -aT";
        lta = "${treeBase} -laT";
      }
    );
  };
}