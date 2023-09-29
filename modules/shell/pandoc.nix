{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.pandoc;
in
{
  options.modules.shell.pandoc = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.pandoc.enable = true;
  };
}
