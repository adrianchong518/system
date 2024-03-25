{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.kicad;
in {
  options.modules.desktop.apps.kicad = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (if (isDarwinHost hostType) then {
    homebrew.casks = [ "kicad" ];
  } else {
    packages = [ pkgs.stable.kicad ];
  });
}
