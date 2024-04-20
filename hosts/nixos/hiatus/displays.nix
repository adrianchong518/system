{ flake, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xrandr
    kanshi
    wdisplays
  ];

  modules.nixos.desktop.de.hyprland.extraSettings = {
    exec-once = [
      "${pkgs.kanshi}/bin/kanshi"
    ];
  };

  hm.services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    profiles =
      let
        builtinDisplay = {
          criteria = "eDP-1";
          status = "enable";
          mode = "2560x1600@240Hz";
          scale = 1.0;
        };

        resetWallpaper = pkgs.writeShellScript "reset-wallpaper" /* bash */ ''
          swww init
          sleep 0.1

          find ${flake}/wallpapers -type f \
            | shuf \
            | head -n 1 \
            | xargs swww img --transition-step 10 --transition-fps 60 \
          && notify-send -u low "wallpaper reset" \
          || notify-send -u critical "wallpaper reset fail"
        '';
        internalPrimary = "${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --primary";
      in
      {
        nomad = {
          outputs = [ builtinDisplay ];
          exec = [ "${resetWallpaper}" internalPrimary ];
        };
        home = {
          outputs = [
            (builtinDisplay // { position = "3440,0"; })
            {
              criteria = "LG Electronics LG ULTRAWIDE 205NTAB2Q984";
              status = "enable";
              mode = "3440x1440@160Hz";
              scale = 1.0;
              position = "0,0";
            }
          ];
          exec = [
            "${resetWallpaper}"
            "${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --primary"
          ];
        };
        multi = {
          outputs = [
            builtinDisplay
            { criteria = "*"; status = "enable"; scale = 1.0; }
          ];
          exec = [ "${resetWallpaper}" internalPrimary ];
        };
      };
  };
}
