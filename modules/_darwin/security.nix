{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.security;
in
{
  options.modules.darwin.security = with types; {
    enableSudoTouchIdAuth = mkBoolOpt false;
  };

  config = mkIf cfg.enableSudoTouchIdAuth {
    security.pam.enableSudoTouchIdAuth = true;
  };
}
