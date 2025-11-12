{
  inputs,
  config,
  options,
  pkgs,
  lib,
  ...
}:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils;
in
{
  options.modules.shell.utils = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [
      coreutils-full
      curl
      wget
      git
      jq
      ripgrep
      fd
      unzip
      p7zip
      gnutar

      pciutils
      usbutils

      fastfetch
      tldr

      just
    ];

    env = {
      PAGER = "${pkgs.less}/bin/less -FR";
      LESS = "-R --mouse";
    };

    modules.shell.aliases.j = "just";

    hm.programs.ripgrep = {
      enable = true;
      arguments = [
        "--hidden"
        "--smart-case"
        "-g!.git"
        "-g!.jj"
      ];
    };
  };
}
