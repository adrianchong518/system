{ inputs, config, pkgs, lib, ... }:

{
  modules = {
    darwin = {
      homebrew.enable = true;

      security.enableSudoTouchIdAuth = true;

      desktop = {
        de = {
          raycast.enable = true;
          amethyst.enable = true;
          hammerspoon.enable = true;
        };

        communication.whatsapp.enable = true;

        apps.utm.enable = true;
        apps.microsoft-office.enable = true;

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
      term.wezterm.enable = true;
      office.libreoffice.enable = true;

      communication = {
        discord.enable = true;
        zoom.enable = true;
      };

      apps = {
        gimp.enable = true;
        obsidian.enable = true;
        zotero.enable = true;
        kicad.enable = true;
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
        lazygit.enable = true;

        signing = {
          enable = true;
          key = "0CF62CE0";
        };
      };
    };

    editors = {
      vscode.enable = true;
      lunarvim.enable = false;
      neovim = {
        enable = true;
        config = "nvchad";
      };
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
      racket.enable = true;
    };
  };

  hm.programs.git.includes =
    let
      ustUser = {
        email = "ncachong@connect.ust.hk";
        signingKey = "5D9B7991";
      };
    in
    [
      {
        condition = "gitdir:~/dev/school/**/.git";
        contents.user = ustUser;
      }
      {
        condition = "gitdir:~/dev/ust-robotics/**/.git";
        contents.user = ustUser;
      }
    ];
}
