{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.darwin.desktop.apps.microsoft-office;
in {
  options.modules.darwin.desktop.apps.microsoft-office = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew.casks = [ "microsoft-office" "microsoft-auto-update" ];
    packages = with pkgs; [ teams ];
  };
}
