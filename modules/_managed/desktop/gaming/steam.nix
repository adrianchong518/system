{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.managed.desktop.gaming.steam;
in
{
  options.modules.managed.desktop.gaming.steam = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf (config.modules.desktop.enable && cfg.enable)
    (
      optionalAttrs (isDarwinHost hostType)
        (mkIf config.modules.darwin.homebrew.enable {
          homebrew.casks = [ "steam" ];
        })
      // optionalAttrs (isNixosHost hostType) {
        programs.steam.enable = true;
      }
    );
}
