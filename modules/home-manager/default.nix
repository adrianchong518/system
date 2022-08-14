{ inputs, config, pkgs, lib, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    ./cli
  ];

  nixpkgs.config = import ../config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../config.nix;

  programs.home-manager = {
    enable = true;
    path = "${homeDir}/.nixpkgs/modules/home-manager";
  };

  home = {
    stateVersion = "22.05";

    packages = with pkgs; [
      grc
      ripgrep
      fd
      tldr
      neofetch
      btop
      bitwarden-cli
      any-nix-shell
    ];

    sessionVariables = {
      EDITOR = "kak";
      MANPAGER = "sh -c 'col -bx | bat -l man -p --paging always'";
    };
  };
}
