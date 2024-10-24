{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  inherit (pkgs.stdenvNoCC) isLinux;
  cfg = config.modules.desktop.communication.discord;
in
{
  options.modules.desktop.communication.discord = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { packages = [ (if isLinux then pkgs.vesktop else pkgs.discord) ]; };
}
