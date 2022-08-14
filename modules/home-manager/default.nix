{ inputs, config, pkgs, lib, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    ./cli
    ./gui
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
      rustup
      btop
      cmake
      gcc
      bitwarden-cli
      any-nix-shell
      nixpkgs-fmt
    ];

    sessionVariables = {
      EDITOR = "kak";
      MANPAGER = "sh -c 'col -bx | bat -l man -p --paging always'";
    };

    sessionPath = [
      "$HOME/.cabal/bin"
      "$HOME/.ghcup/bin"
    ];
  };
}
