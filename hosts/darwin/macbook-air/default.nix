{ inputs, config, pkgs, lib, ... }:

{
  modules = {
    darwin.homebrew.enable = true;

    desktop = {
      enable = true;
      browsers.firefox.enable = true;
      term.alacritty.enable = true;
    };

    editors = {
      vscode.enable = true;
      neovim = {
        enable = true;
        enablePlugins = true;
      };

      default = "nvim";
    };

    shell = {
      fish.enable = true;
      default = config.modules.shell.fish.package;

      starship.enable = true;
      utils.enable = true;
      git.lazygit.enable = true;
    };

    services = {
      ssh.enable = true;
    };
  };
}
