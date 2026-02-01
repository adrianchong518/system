{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.thunar;
in
{
  options.modules.nixos.desktop.utils.thunar = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    packages = [ pkgs.file-roller ];

    programs = {
      xfconf.enable = true;

      thunar = {
        enable = true;

        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images

    hm.xdg.mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
  };
}
