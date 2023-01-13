{ config, lib, pkgs, ... }:

{
  homebrew = {
    casks = [
      # communication
      "whatsapp"
      "zoom"
      "discord"

      # office
      "libreoffice"

      "obsidian"
      "steam"
      "gimp"

      # driver
      "mos"
    ];

    masApps = {
      EasyRes = 688211836;
      HandMirror = 1502839586;
    };
  };
}
