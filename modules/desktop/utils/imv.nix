{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.utils.imv;
in
{
  options.modules.desktop.utils.imv = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.imv = {
      enable = true;
      settings = {
        options = {
          background = "1e1e2e";
          overlay_text_color = "cdd6f4";
          overlay_background_color = "11111b";
        };
      };
    };

    hm.xdg.mimeApps.defaultApplications = {
      "image/png" = "imv.desktop";
      "image/jpg" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/bmp" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
    };
  };
}
