{ config, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.term.foot;
in
{
  options.modules.desktop.term.foot = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.foot = {
      enable = true;

      settings = {
        main = {
          font = "Iosevka Nerd Font:size=11";
        };
        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
