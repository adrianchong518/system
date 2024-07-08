{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.managed.docker;
in
{
  options.modules.managed.docker = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable (
    (optionalAttrs (isDarwinHost hostType) {
      homebrew.casks = [ "docker" ];
    })
    // (optionalAttrs (isNixosHost hostType) {
      virtualisation.docker.enable = true;
      my.user.extraGroups = [ "docker" ];
    })
  );
}
