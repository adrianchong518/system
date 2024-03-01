{ inputs, lib, ... }:

with lib;
with lib.my; {
  imports = importModulesRec ./.
    ++ [ inputs.home-manager.nixosModules.home-manager ];

  system.stateVersion = "23.05";

  user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  services.openssh.enable = true;

  services.gnome.gnome-keyring.enable = true;
}
