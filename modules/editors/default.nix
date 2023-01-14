{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors;
in
{
  options.modules.editors = with types; {
    default = mkOpt (nullOr str) null;
  };

  config = mkIf (cfg.default != null) {
    env.EDITOR = cfg.default;
  };
}
