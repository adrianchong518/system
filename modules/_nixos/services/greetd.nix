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
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${cfg.session}";
          user = config.my.user.name;
        };
        default_session = {
          command = "agreety --cmd ${cfg.session}";
          user = config.my.user.name;
        };
      };
    };
  };
}
