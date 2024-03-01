{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
  };

  modules = {
    nixos = {
      services = {
        pipewire.enable = true;
      };

      desktop = {
        de.plasma6.enable = true;
      };
    };

    managed.desktop.gaming.steam.enable = true;

    desktop = {
      enable = true;
      browsers.firefox.enable = true;
      term.wezterm.enable = true;
      # office.libreoffice.enable = true;

      communication = {
        # discord.enable = true;
        # zoom.enable = true;
      };

      apps = {
        thunderbird.enable = true;
        # gimp.enable = true;
        # obsidian.enable = true;
        # zotero.enable = true;
        # kicad.enable = true;
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
        # TODO: signing
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

  # TODO:
  /*
    hm.programs.git.includes = [
    {
      condition = "gitdir:~/dev/hkust/";
      contents.user = {
        email = "ncachong@connect.ust.hk";
        signingKey = "5D9B7991";
      };
    }
    ];
  */
}
