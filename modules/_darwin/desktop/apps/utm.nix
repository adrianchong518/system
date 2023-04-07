{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.desktop.apps.utm;
in
{
  options.modules.darwin.desktop.apps.utm = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "utm"
    ];
  };
}
