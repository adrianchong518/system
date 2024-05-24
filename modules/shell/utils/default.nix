{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.utils;
in {
  options.modules.shell.utils = with types; { enable = mkBoolOpt false; };

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
      gnutar

      fastfetch
      tldr
    ];

    env = {
      PAGER = "${pkgs.less}/bin/less -FR";
      LESS = "-R --mouse";
    };
  };
}
