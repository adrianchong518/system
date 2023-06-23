{ inputs, lib, ... }:

with lib;
with lib.my;
{
  imports =
    importModulesRec ./.
    ++ [
      inputs.home-manager.nixosModules.home-manager
    ];

  system.stateVersion = "23.05";

  user.extraGroups = [ "wheel" ];
}
