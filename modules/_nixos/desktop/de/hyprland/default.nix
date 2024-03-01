{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.de.hyprland;
in
{
  options.modules.nixos.desktop.de.hyprland = with types; {
    enable = mkBoolOpt false;
    WLR_DRM_DEVICES = mkOpt str "";
    extraSettings = mkOpt attrs { };
    extraConfig = mkOpt lines "";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    hm.wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        source = [ "${./hyprland.conf}" ]
          ++ optional config.modules.nixos.services.pipewire.enable "${./pipewire.conf}";
      } // optionalAttrs config.modules.nixos.hardware.nvidia.enable {
        env = [
          "LIBVA_DRIVER_NAME,nvidia"
          "XDG_SESSION_TYPE,wayland"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "WLR_NO_HARDWARE_CURSORS,1"
          "WLR_DRM_DEVICES,${cfg.WLR_DRM_DEVICES}"
        ];
      } // (
        let displayCfg = config.modules.nixos.hardware.display;
        in optionalAttrs displayCfg.brightnessctl.enable {
          bind = [
            ", XF86MonBrightnessDown, exec, brightnessctl -d ${displayCfg.defaultDevice} set 5%-"
            ", XF86MonBrightnessUp, exec, brightnessctl -d ${displayCfg.defaultDevice} set 5%+"
          ];
        }
      ) // cfg.extraSettings;

      extraConfig = mkAliasDefinitions options.modules.nixos.desktop.de.hyprland.extraConfig;
    };
  };
}
