{ config, lib, pkgs, ... }: {
  user.name = "adrianchong";
  hm = { imports = [ ./home-manager/personal.nix ]; };
}
