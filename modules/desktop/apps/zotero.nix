{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.zotero;
in {
  options.modules.desktop.apps.zotero = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (if (isDarwinHost hostType) then {
    homebrew.casks = [ "zotero" ];
  } else {
    packages = [ pkgs.zotero ];
  });
}
