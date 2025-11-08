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

      libsForQt5.qt5.qtwayland
    ];
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    } // optionalAttrs config.modules.nixos.hardware.nvidia.enable {
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      # WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
