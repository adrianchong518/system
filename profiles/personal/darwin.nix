{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenvNoCC.isDarwin {
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
    ];

    masApps = {
      EasyRes = 688211836;
      HandMirror = 1502839586;
    };
  };
}
