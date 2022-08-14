{ config, lib, pkgs, ... }:

{
  imports = [
    ./darwin.nix
  ];

  user.name = "adrianchong";
  hm = { imports = [ ./home-manager.nix ]; };
}
