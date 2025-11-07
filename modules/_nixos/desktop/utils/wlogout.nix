{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.wlogout;
in
{
  options.modules.nixos.desktop.utils.wlogout = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.wlogout = {
      enable = true;
      package = pkgs.wlogout.overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.wrapGAppsHook3 ];
        buildInputs = old.buildInputs ++ [ pkgs.librsvg ];
      });
      style =
        let
          hmCfg = config.home-manager.users.${config.my.user.name};
          cfg = hmCfg.catppuccin.wlogout;
          sources = hmCfg.catppuccin.sources;
        in
        lib.concatStrings [
          ''
            @import url("${sources.wlogout}/themes/${cfg.flavor}/${cfg.accent}.css");
          ''
          (lib.concatMapStrings
            (icon: ''
              #${icon} {
                background-image: image(url("${sources.wlogout}/icons/${cfg.iconStyle}/${cfg.flavor}/${cfg.accent}/${icon}.svg"));
              }
            '')
            [
              "hibernate"
              "lock"
              "logout"
              "reboot"
              "shutdown"
              "suspend"
            ]
          )
          cfg.extraStyle
        ];
    };

    hm.catppuccin.wlogout.enable = false;
  };
}
