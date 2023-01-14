{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.desktop.de.raycast;
in
{
  options.modules.darwin.desktop.de.raycast = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "raycast"
    ];
  };
}
