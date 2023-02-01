{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.fonts.fontconfig.enable = true;

    packages = with pkgs; [
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

      source-han-serif
      source-han-sans
    ];
  };
}
