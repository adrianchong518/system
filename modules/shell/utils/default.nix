{ inputs, config, options, pkgs, lib, ... }:

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

      neofetch
      tldr
      btop
    ];
  };
}
