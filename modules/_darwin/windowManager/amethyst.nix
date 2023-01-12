{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.windowManager.amethyst;
in
{
  options.modules.darwin.windowManager.amethyst = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf (config.modules.desktop.enable && config.modules.darwin.homebrew.enable && cfg.enable) {
    homebrew.casks = [
      "amethyst"
    ];
  };
}
