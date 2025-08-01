{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.gpg;
in {
  options.modules.services.gpg = with types; {
    enable = mkBoolOpt false;
    pinentryPackage = mkOpt package pkgs.pinentry-gnome3;
  };

  config = mkIf cfg.enable ({
    packages = [ pkgs.gnupg ];

    hm.programs.gpg.enable = true;
  } // optionalAttrs (isNixosHost hostType) {
    hm.services.gpg-agent = {
      enable = true;
      pinentry.package = cfg.pinentryPackage;
    };
  });
}
