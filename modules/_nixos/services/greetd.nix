{ config, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.services.greetd;
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  options.modules.nixos.services.greetd = with types; {
    enable = mkBoolOpt false;
    session = mkOpt str "${tuigreet}";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${cfg.session}";
          user = config.user.name;
        };
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${cfg.session}";
          user = "greeter";
        };
      };
    };
  };
}
