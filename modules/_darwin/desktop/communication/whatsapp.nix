{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.darwin.desktop.communication.whatsapp;
in {
  options.modules.darwin.desktop.communication.whatsapp = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { homebrew.casks = [ "whatsapp" ]; };
}
