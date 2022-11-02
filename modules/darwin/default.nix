{ inputs, pkgs, lib, ... }:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];
}
