{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.darwin.desktop.de.amethyst;
in {
  options.modules.darwin.desktop.de.amethyst = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { homebrew.casks = [ "amethyst" ]; };
}
