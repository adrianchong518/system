{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.services.greetd;
in
{
  options.modules.nixos.services.greetd = with types; {
    enable = mkBoolOpt false;
    session = mkOpt str "${config.my.user.shell}";
    autoLogin = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = if cfg.autoLogin then "${cfg.session}" else default_session.command;
          user = config.my.user.name;
        };
        default_session = {
          command = "${config.services.greetd.package}/bin/agreety --cmd ${cfg.session}";
          user = config.my.user.name;
        };
      };
    };
  };
}
