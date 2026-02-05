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

    profiles =
      let
        builtinDisplay = {
          criteria = "eDP-1";
          status = "enable";
          mode = "2560x1600@60Hz";
          scale = 1.0;
        };

        internalPrimary = "${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --primary";
      in
      {
        nomad = {
          outputs = [ builtinDisplay ];
          exec = [
            internalPrimary
          ];
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
            "${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --primary"
          ];
        };
        multi = {
          outputs = [
            builtinDisplay
            { criteria = "*"; status = "enable"; scale = 1.0; }
          ];
          exec = [
            internalPrimary
          ];
        };
      };
  };
}
