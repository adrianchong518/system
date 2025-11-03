{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop;
  fontPkgs = with pkgs; [
    iosevka-bin

    source-han-serif
    source-han-sans

    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    helvetica-neue-lt-std
  ] ++ (with nerd-fonts; [
    iosevka
    iosevka-term
    symbols-only
  ]);
in
{
  options.modules.desktop = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable ({
    hm.fonts.fontconfig.enable = true;
    packages = fontPkgs;
  } // optionalAttrs (isNixosHost hostType) {
    fonts = {
      packages = fontPkgs;
      fontDir.enable = true;
      fontconfig = {
        defaultFonts = {
          serif = [
            "Noto Serif"
            "Noto Serif CJK HK"
            "Noto Color Emoji"
          ];
          sansSerif = [
            "Noto Sans"
            "Noto Sans CJK HK"
            "Noto Color Emoji"
          ];
          monospace = [
            "Iosevka Nerd Font Mono"
            "Noto Color Emoji"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  });
}
