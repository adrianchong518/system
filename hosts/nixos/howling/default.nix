{ inputs, options, config, pkgs, lib, ... }:

with lib;
{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
    ./hardware-configuration.nix
    ./displays.nix
  ];

  services = {
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    onedrive.enable = true;
  };


  # gnome-keyring auto login
  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    # powertop
    # wineWowPackages.waylandFull
  ];

  services.tailscale.enable = true;
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "taildf7228.ts.net" ];
  services.tailscale.useRoutingFeatures = "client";
  networking.firewall.checkReversePath = "loose";

  packages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli

    # XXX: not supported
    # my.stm32cubemx

    teams-for-linux

    distrobox
    # winboat

    typst
    texlive.combined.scheme-full
  ];

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
    dbus.lib
    libglvnd
    libusb1
    libxkbcommon
    mesa
    SDL2
    systemdLibs
    xorg.libICE
    xorg.libSM
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
  ]);

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-rime
      fcitx5-mozc
      fcitx5-gtk
      nur.repos.linyinfeng.rimePackages.rime-cantonese
      nur.repos.linyinfeng.rimePackages.rime-luna-pinyin
    ];
  };
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  hm.services.udiskie.enable = true;

  modules = {
    nixos = {
      udev.openocd.enable = true;

      services = {
        transmission.enable = true;
        kanata.enable = true;
      };

      desktop = {
        de.niri.enable = true;

        apps = {
          virt-manager = {
            enable = true;
          };
        };
      };
    };

    # XXX: may not support?
    # managed.desktop.gaming.steam.enable = true;
    managed.docker.enable = true;

    desktop = {
      enable = true;
      browsers.firefox.enable = true;
      term.wezterm.enable = true;
      office.libreoffice.enable = true;

      communication = {
        discord.enable = true;
        zoom.enable = true;
      };

      apps = {
        thunderbird.enable = true;
        gimp.enable = true;
        zotero.enable = true;
        zathura.enable = true;
        kicad.enable = true;
      };

      utils = {
        imv.enable = true;
        mpv.enable = true;
      };
    };

    shell = {
      fish.enable = true;
      default = config.modules.shell.fish.package;

      starship.enable = true;
      utils.enable = true;

      pandoc.enable = true;

      git = {
        gh.enable = true;
        signing = {
          enable = true;
          key = "1DC233DD";
        };
      };
    };

    editors = {
      vscode.enable = true;
      neovim.enable = true;
      default = "nvim";
    };

    services = {
      ssh = {
        enable = true;
      };
      gpg.enable = mkForce true;
    };

    dev = {
      # platformio.enable = true;
    };
  };

  hm.programs.git.includes = [
    {
      condition = "gitdir:~/dev/hkust/";
      contents.user = {
        email = "ncachong@connect.ust.hk";
        signingKey = "6EEB1719";
      };
    }
  ];
}
