{ inputs, lib, hostType, ... }:

with lib;
with lib.my;
{
  imports = importModulesRec ./.
    ++ optional (isManagedSystem hostType) ./_managed.nix
    ++ optional (isDarwinHost hostType) ./_darwin
    ++ optional (isNixosHost hostType) ./_nixos;
}
