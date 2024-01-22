{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  options.modules.desktop = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    hm.fonts.fontconfig.enable = true;

    packages = with pkgs; [
      iosevka-bin

      (nerdfonts.override {
        fonts = [ "Iosevka" "IosevkaTerm" "NerdFontsSymbolsOnly" ];
      })

      source-han-serif
      source-han-sans
    ];
  };
}
