{ inputs, options, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./displays.nix
    "${inputs.nixpkgs-howdy}/nixos/modules/security/pam.nix"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/security/howdy/default.nix"
    "${inputs.nixpkgs-howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
  ];

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [ sane-airscan hplipWithPlugin ];
    disabledDefaultBackends = [ "escl" ];
  };

  my.user.extraGroups = [ "scanner" "lp" ];

  services = {
    gnome.gnome-keyring.enable = true;
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    flatpak.enable = true;

    howdy = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
      settings = {
        core = {
          detection_notice = true;
          no_confirmation = true;
        };

        video = {
          device_path = "/dev/video2";
          dark_threshold = 90;
          frame_width = 640;
          frame_height = 360;
          device_fps = 15;
        };
      };
    };

    # in case your IR blaster does not blink, run `sudo linux-enable-ir-emitter configure`
    linux-enable-ir-emitter = {
      enable = false;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    };

    onedrive.enable = true;
  };

  disabledModules = [ "security/pam.nix" ];

  # gnome-keyring auto login
  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    powertop
    intel-gpu-tools
    wineWowPackages.waylandFull
    nvtopPackages.full
  ];

  services.tailscale.enable = true;
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "taildf7228.ts.net" ];
  services.tailscale.useRoutingFeatures = "client";
  networking.firewall.checkReversePath = "loose";

  packages = with pkgs; [
    bitwarden
    bitwarden-cli

    prismlauncher

    my.stm32cubemx

    simple-scan

    teams-for-linux
    gnome-network-displays

    devenv
  ];

  networking.firewall.allowedTCPPorts = [ 7236 7250 ];
  networking.firewall.allowedUDPPorts = [ 7236 5353 ];
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];

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

  programs.kdeconnect.enable = true;
  hm.services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  virtualisation.docker.storageDriver = "btrfs";
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    registrations.aarch64-linux = {
      fixBinary = true;
      matchCredentials = true;
    };
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      rime-data
      fcitx5-rime
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-catppuccin
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
        # de.plasma6.enable = true;
        de.hyprland = {
          enable = true;
          extraSettings = {
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
        obsidian.enable = false;
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

      tmux.enable = true;

      starship.enable = true;
      utils.enable = true;
      yazi.enable = true;

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

    dev = {
      platformio.enable = true;
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
