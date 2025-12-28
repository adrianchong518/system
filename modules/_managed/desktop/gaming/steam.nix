{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules.managed.desktop.gaming.steam;
in {
  options.modules.managed.desktop.gaming.steam = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable
    (optionalAttrs (isDarwinHost hostType) { homebrew.casks = [ "steam" ]; }
      // optionalAttrs (isNixosHost hostType) {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
      };
      packages = [ pkgs.gamescope ];
    });
}
