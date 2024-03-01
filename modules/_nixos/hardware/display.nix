{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.hardware.display;
in
{
  options.modules.nixos.hardware.display = with types; {
    brightnessctl.enable = mkBoolOpt false;
    defaultDevice = mkOpt str "intel_backlight";
  };

  config = {
    packages = mkIf cfg.brightnessctl.enable [ pkgs.brightnessctl ];
  };
}
