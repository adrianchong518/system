{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  inherit (pkgs.stdenvNoCC) isDarwin;

  cfg = config.modules.desktop.office.libreoffice;
in
{
  options.modules.desktop.office.libreoffice = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    packages = with pkgs;
      [ (if isDarwin then libreoffice-bin else libreoffice-qt) ];
  };
}
