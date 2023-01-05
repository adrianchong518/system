{ inputs, pkgs, lib, ... }:

{
  modules = {
    darwin.homebrew.enable = true;

    desktop = {
      enable = true;
      browsers.firefox.enable = true;
      term.alacritty.enable = true;
    };

    shell = {
      fish.enable = true;
      starship.enable = true;
      utils.enable = true;
      git.lazygit.enable = true;
    };

    services = {
      ssh.enable = true;
    };
  };
}
