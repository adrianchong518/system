{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.swaybg;
in
{
  options.modules.nixos.desktop.utils.swaybg = with types; {
    enable = mkBoolOpt false;
    wallpaperDir = mkOpt str "${config.files.configHome}/wallpaper";
  };
  config = mkIf cfg.enable (
    let
      setWallpaper = pkgs.writeShellScriptBin "swaybg-set-wallpaper" ''
        WALLPAPER_DIR="${cfg.wallpaperDir}"
        if [ -d "$WALLPAPER_DIR" ]; then
          FILE=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
          ${pkgs.swaybg}/bin/swaybg -i "$FILE" -m fill &
        fi
      '';
    in
    {
      packages = [ pkgs.swaybg setWallpaper ];
    }
  );
}
