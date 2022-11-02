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

  config = mkIf cfg.enable (
    { }
    // optionalAttrs (isManagedSystem hostType) {
      fonts = {
        fontDir.enable = true;
        fonts = with pkgs; [
          jetbrains-mono
          (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];
      };
    }
  );
}
