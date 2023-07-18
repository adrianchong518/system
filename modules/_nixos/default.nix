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

  user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  time.timeZone = "Hongkong";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager.defaultSession = "xfce";

    # Configure keymap in X11
    layout = "us";
    xkbVariant = "colemak";
    xkbOptions = "caps:escape";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;

  # vscode-server
  services.vscode-server.enable = true;
}
