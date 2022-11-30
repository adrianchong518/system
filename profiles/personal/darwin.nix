{ config, lib, pkgs, ... }:

{
  homebrew = {
    casks = [
      # communication
      "whatsapp"
      "wechat"
      "zoom"
      "discord"
      "microsoft-teams"

      # cloud
      "google-drive"

      # office
      "libreoffice"
      "microsoft-office"
      "microsoft-auto-update"

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
