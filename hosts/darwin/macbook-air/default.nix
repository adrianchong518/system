{ flake, inputs, config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  nixpkgs.overlays = flake.overlays;
}
