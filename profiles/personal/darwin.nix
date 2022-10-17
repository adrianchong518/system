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
      "microsoft-auto-update"

      "obsidian"
      "steam"

      # driver
      "logi-options-plus"
    ];

    masApps = {
      EasyRes = 688211836;
      HandMirror = 1502839586;
    };
  };
}
