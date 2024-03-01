{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.gpg;
in {
  options.modules.services.gpg = with types; {
    enable = mkBoolOpt false;
    pinentryFlavor = mkOpt (nullOr str) null;
  };

  config = mkIf cfg.enable ({
    hm.programs.gpg.enable = true;
  } // optionalAttrs (isNixosHost hostType) {
    programs.gnupg.agent = {
      enable = true;
      pinentryFlavor = cfg.pinentryFlavor;
    };
  });
}
