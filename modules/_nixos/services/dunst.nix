{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.services.dunst;
in
{
  options.modules.nixos.services.dunst = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.services.dunst = {
      enable = true;
      iconTheme = {
        package = pkgs.gnome.adwaita-icon-theme;
        name = "Adawaita";
      };
      settings = {
        global = {
          font = "Iosevka Nerd Font 11";
        };
      };
    };
  };
}
