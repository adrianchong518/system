{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.thunderbird;
in {
  options.modules.desktop.apps.thunderbird = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable
    ({
      hm.programs.thunderbird = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isx86 then pkgs.stable.thunderbird-bin else pkgs.stable.thunderbird;
        profiles.default = {
          isDefault = true;
        };
      };
    } // optionalAttrs (isDarwinHost hostType) {
      hm.programs.thunderbird.package = pkgs.runCommand "thunderbird-0.0.0" { } "mkdir $out";
      homebrew.casks = [ "thunderbird" ];
    });
}
