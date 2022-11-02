{ inputs, lib, hostType, ... }:

with lib;
with lib.my;
{
  imports = [
    ./desktop
    ./nixpkgs
    ./options.nix
  ]
  ++ optional (isManagedSystem hostType) ./managed
  ++ optional (isDarwinHost hostType) ./darwin
  ++ optional (isNixosHost hostType) ./nixos;
}
