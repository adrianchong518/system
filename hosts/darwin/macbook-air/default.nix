{ inputs, config, pkgs, lib, ... }:

{
  modules = {
    darwin = {
      homebrew.enable = true;

      desktop = {
        de = {
          raycast.enable = true;
          amethyst.enable = true;
        };

        communication.whatsapp.enable = true;

        utils = {
          enable = true;
          aldente.enable = true;
          iina.enable = true;
          handMirror.enable = true;
        };
      };
    };

    managed.desktop.gaming.steam.enable = true;

    desktop = {
      enable = true;
      browsers.firefox.enable = true;
      term.alacritty.enable = true;
      office.libreoffice.enable = true;

      communication = {
        discord.enable = true;
        zoom.enable = true;
      };

      apps = {
        gimp.enable = true;
        obsidian.enable = true;
      };
    };

    shell = {
      fish.enable = true;
      default = config.modules.shell.fish.package;

      starship.enable = true;
      utils.enable = true;
      git.lazygit.enable = true;
    };

    editors = {
      vscode.enable = true;
      neovim = {
        enable = true;
        enablePlugins = true;
      };

      default = "nvim";
    };

    services = {
      ssh.enable = true;
    };
  };
}
