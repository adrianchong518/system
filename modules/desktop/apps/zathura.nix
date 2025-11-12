{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.zathura;
in {
  options.modules.desktop.apps.zathura = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable ({
    hm.programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        scroll-step = "200";
        scroll-hstep = "200";
      };

      extraConfig = mkAfter ''
        set recolor "false"
      '';
    };
  } // optionalAttrs (isNixosHost hostType) {
    xdg.mime.defaultApplications."application/pdf" = "org.pwmt.zathura.desktop";
  });
}
