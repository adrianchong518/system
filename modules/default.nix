{ inputs, lib, hostType, ... }:

with lib;
with lib.my;
{
  imports = [
    ./options.nix
  ]
  ++ optional (isDarwinHost hostType) ./darwin
  ++ optional (isNixosHost hostType) ./nixos;

  nixpkgs.overlays = import ../overlays { inherit inputs lib; };
}
