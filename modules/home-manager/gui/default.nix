{ config, pkgs, lib, ... }:

{
  imports = [
    ./kitty.nix
    ./vscode
  ];
}
