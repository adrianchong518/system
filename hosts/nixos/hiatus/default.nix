{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
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

  modules = {
    nixos = {
      udev.openocd.enable = true;

      desktop = {
        # de.plasma6.enable = true;
        de.hyprland = {
          enable = true;
          extraSettings = {
            monitor = [
              "eDP-1, 2560x1600@120, 0x0, 1, vrr,1"
              "desc:LG Electronics LG ULTRAWIDE 205NTAB2Q984, 3440x1440@160, -3440x0, 1"
            ];
          };
          extraConfig = ''
            device {
              name = asup1207:00-093a:3012-touchpad
              sensitivity = 0.2
            }
          '';
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
        # kicad.enable = true; TODO: BROKEN?
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
      gpg = {
        enable = true;
        pinentryFlavor = "gnome3";
      };
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
