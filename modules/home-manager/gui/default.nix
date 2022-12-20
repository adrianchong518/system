{ config, pkgs, lib, ... }:

{
  imports = [
    ./alacritty
    # ./kitty.nix
    ./vscode
  ];

  home.packages = with pkgs; [
    (if system == "aarch64-linux" then firefox else firefox-bin)
  ];
}
