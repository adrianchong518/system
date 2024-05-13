{ inputs, lib, ... }:

with lib;
with lib.my; {
  imports = importModulesRec ./.
    ++ [ inputs.home-manager.nixosModules.home-manager ];

  system.stateVersion = "23.05";

  my.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  time.timeZone = "Hongkong";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "colemak";
      options = "ctrl:nocaps";
    };

    libinput.enable = true;
  };
}
