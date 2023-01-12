{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.raycast;
in
{
  options.modules.darwin.raycast = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf (config.modules.desktop.enable && config.modules.darwin.homebrew.enable && cfg.enable) {
    homebrew.casks = [
      "raycast"
    ];
  };
}
