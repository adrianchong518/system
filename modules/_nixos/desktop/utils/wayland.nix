{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.wayland;
in
{
  options.modules.nixos.desktop.utils.wayland = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wlr-randr
      wl-clipboard
    ];
  };
}
