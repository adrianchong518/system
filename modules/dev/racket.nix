{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.racket;
in
{
  options.modules.dev.racket = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable
    (
      if isDarwinHost hostType then {
        homebrew.casks = [ "racket" ];
      } else {
        packages = if isLinux then [ pkgs.racket ] else (throw "racket should be broken on this system");
      }
    );
}
