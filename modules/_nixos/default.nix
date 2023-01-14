{ inputs, lib, ... }:

with lib;
with lib.my;
{
  imports =
    importModulesRec ./.
    ++ [
      inputs.home-manager.nixosModules.home-manager
    ];

  system.stateVersion = "22.11";

  user.extraGroups = [ "wheel" ];
}
