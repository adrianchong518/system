{ inputs, lib, hostType, ... }:

with lib;
with lib.my;
{
  imports = [
    ./desktop
    ./nixpkgs
    ./options.nix
  ]
  ++ optional (isManagedSystem hostType) ./managed.nix
  ++ optional (isDarwinHost hostType) ./darwin
  ++ optional (isNixosHost hostType) ./nixos;
}
