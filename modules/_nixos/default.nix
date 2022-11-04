{ inputs, lib, ... }:

with lib;
with lib.my;
{
  imports =
    importModulesRec ./.
    ++ [
      inputs.home-manager.nixosModules.home-manager
    ];
}
