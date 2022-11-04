{ inputs, lib, hostType, ... }:

with lib;
with lib.my;
{
  imports = [
    ./nixpkgs
  ]
  ++ optional (isManagedSystem hostType) ./managed.nix
  ++ optional (isDarwinHost hostType) ./darwin
  ++ optional (isNixosHost hostType) ./nixos;
}
