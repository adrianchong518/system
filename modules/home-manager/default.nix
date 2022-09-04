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

    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "sh -c 'col -bx | bat -l man -p --paging always'";

      # https://github.com/NixOS/nixpkgs/issues/24311
      SSH_ASKPASS = "";
      GIT_ASKPASS = "";
    };
  };
}
