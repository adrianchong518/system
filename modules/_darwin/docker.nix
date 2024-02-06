{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.docker;
in
{
  options.modules.darwin.docker = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    homebrew.casks = [ "docker" ];
  };
}
