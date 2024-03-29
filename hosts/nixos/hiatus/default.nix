{ inputs, options, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    flatpak.enable = true;
  };

  # gnome-keyring auto login
  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    powertop
    intel-gpu-tools
  ];

  packages = with pkgs; [
    bitwarden
    bitwarden-cli
    teams-for-linux
    whatsapp-for-linux
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
    dbus.lib
    libglvnd
    libusb1
    libxkbcommon
    mesa
    mesa.drivers
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

  modules = {
    nixos = {
      udev.openocd.enable = true;

      services.transmission.enable = true;

      desktop = {
        # de.plasma6.enable = true;
        de.hyprland = {
          enable = true;
          extraSettings = {
            monitor = [
              "eDP-1, 2560x1600@120, 0x0, 1, vrr,1"
              "desc:LG Electronics LG ULTRAWIDE 205NTAB2Q984, 3440x1440@160, -3440x0, 1"
            ];
            env = [
              "WLR_DRM_DEVICES,${config.files.dataHome}/_dri/intel-card:${config.files.dataHome}/_dri/nvidia-card"
            ];
          };
          extraConfig = ''
            device {
              name = asup1207:00-093a:3012-touchpad
              sensitivity = 0.2
            }
          '';
        };

        apps = {
          virt-manager = {
            enable = true;
            gpuPCIE = "0000:00:02.0";
          };
        };
      };
    };

    managed.desktop.gaming.steam.enable = true;

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
        obsidian.enable = true;
        zotero.enable = true;
        zathura.enable = true;
        kicad.enable = true;
      };

      utils = {
        feh.enable = true;
        mpv.enable = true;
      };
    };

    shell = {
      fish.enable = true;
      default = config.modules.shell.fish.package;

      tmux.enable = true;

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
      jujutsu.enable = true;
    };

    editors = {
      vscode.enable = true;
      neovim.enable = true;
      default = "nvim";
    };

    services = {
      ssh = {
        enable = true;
        git = {
          enable = true;
          identityFile = "~/.ssh/id_ed25519_git";
        };
      };
      gpg.enable = true;
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
