{ config, pkgs, lib, ... }:

{
  imports = [
    ./kitty.nix
    ./vscode
  ];

  home.packages = with pkgs; [ ];
}
