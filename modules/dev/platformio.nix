{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  inherit (pkgs.stdenvNoCC) isLinux;

  cfg = config.modules.dev.platformio;
in
{
  options.modules.dev.platformio = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable
    (
      if isDarwinHost hostType then {
        homebrew.brews = [ "platformio" ];
      } else {
        packages =
          if isLinux then
            [ pkgs.platformio ]
          else
            (throw "platformio is not supported on this system");
      } // optionalAttrs (isNixosHost hostType)
        {
          services.udev.packages = [ pkgs.platformio-core.udev ];
        }
    );
}
