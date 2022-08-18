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
      "microsoft-office"

      # obsidian
      "obsidian"

      # steam
      "steam"
    ];

    masApps = {
      EasyRes = 688211836;
      HandMirror = 1502839586;
    };
  };
}
