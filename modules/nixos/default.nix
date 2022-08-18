{ config, pkgs, lib, ... }:

{
  imports = [
    ../common.nix
    ./nixpkgs.nix
  ];

  time.timeZone = "Hongkong";
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    defaultUserShell = pkgs.fish;
    mutableUsers = false;
    users = {
      "${config.user.name}" = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        hashedPassword = "$6$QigNSajFRcGnIvxf$vrXIdhu1v9MRw9h5ZcpAr.ZbYrzD7NzgvGfDzqUNlWxm9r4p1oeh09HGBjhzyFb2fxUMxcG5YXhzX5dwPg43N10";
      };
    };
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
