{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vscode;
in {
  options.modules.editors.vscode = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    hm.programs.vscode = { enable = true; };
    hm.catppuccin.vscode.profiles.default.enable = false;
  };
}
