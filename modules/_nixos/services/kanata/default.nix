{ pkgs, lib, config, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.services.kanata;
in
{
  options.modules.nixos.services.kanata = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.kanata = {
      enable = true;
      package = pkgs.kanata-with-cmd;

      keyboards.default = {
        configFile = ./default.kbd;
      };
    };
  };
}
