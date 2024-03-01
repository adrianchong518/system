{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModprobeConfig = ''
    options i915 enable_dpcd_backlight=1
  '';
  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  services.hardware.bolt.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  modules = {
    nixos = {
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
        # thunderbird.enable = true;
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
        /*
        signing = {
          enable = true;
          key = "0CF62CE0";
        };
        */
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
      gpg.enable = true;
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
