{ lib, config, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.ai.omp;
in
{
  options.modules.ai.omp = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.omp = {
      enable = true;
    };
  };
}
