{ config, pkgs, lib, ... }:

{
  imports = [
    ./darwin.nix
  ];

  hm = { imports = [ ../../modules/home-manager/gui ]; };
}
