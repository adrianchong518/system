{ flake, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xrandr
    kanshi
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
          mode = "2560x1600@120";
          scale = 1.0;
        };

        resetWallpaper = "${pkgs.bash}/bin/bash -c \"find ${flake}/wallpapers -type f | shuf | head -n 1 | xargs swww img --transition-step 10 --transition-fps 60\" && notify-send \"wallpaper reset\" || notify-send -u critical \"wallpaper reset fail\", reset wallpaper";
      in
      {
        nomad = {
          outputs = [ builtinDisplay ];
        };
        pluggedIn = {
          outputs = [ (builtinDisplay // { mode = "2560x1600@240"; }) ];
        };
        home = {
          outputs = [
            (builtinDisplay // { mode = "2560x1600@240"; position = "3440,0"; })
            {
              criteria = "LG Electronics LG ULTRAWIDE 205NTAB2Q984";
              status = "enable";
              mode = "3440x1440@160";
              scale = 1.0;
              position = "0,0";
            }
          ];
          exec = [ resetWallpaper ];
        };
        multimonitors = {
          outputs = [
            builtinDisplay
            { criteria = "*"; }
          ];
          exec = [ resetWallpaper ];
        };
      };
  };
}
