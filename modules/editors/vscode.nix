{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.vscode;
in
{
  options.modules.editors.vscode = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf (config.modules.desktop.enable && cfg.enable) {
    hm. programs.vscode = {
      enable = true;
    };
  };
}
