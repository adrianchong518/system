{ flake, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xrandr
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

    settings =
      let
        builtinDisplay = {
          criteria = "eDP-1";
          status = "enable";
          mode = "2560x1600@240Hz";
          position = "0,0";
          scale = 1.0;
        };

        internalPrimary = "${pkgs.xrandr}/bin/xrandr --output eDP-1 --primary";
      in
      [
        {
          profile = {
            name = "nomad";
            outputs = [ builtinDisplay ];
            exec = [
              internalPrimary
            ];
          };
        }
        {
          profile = {
            name = "home";
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
              "${pkgs.xrandr}/bin/xrandr --output DP-1 --primary"
            ];
          };
        }
        {
          profile = {
            name = "lab";
            outputs = [
              (builtinDisplay // { position = "0,1080"; })
              {
                criteria = "STD*";
                status = "enable";
                mode = "1920x1080@60Hz";
                scale = 1.0;
                position = "320,0";
              }
            ];
            exec = [
              internalPrimary
            ];
          };
        }
        {
          profile = {
            name = "lab2";
            outputs = [
              builtinDisplay
              {
                criteria = "Integrated Tech Express Inc DP2HDMI*";
                status = "enable";
                mode = "1920x1080@60Hz";
                scale = 1.0;
                position = "2560,0";
              }
            ];
            exec = [
              internalPrimary
            ];
          };
        }
        {
          profile = {
            name = "multi";
            outputs = [
              builtinDisplay
              { criteria = "*"; status = "enable"; scale = 1.0; }
            ];
            exec = [
              internalPrimary
            ];
          };
        }
      ];
  };
}
