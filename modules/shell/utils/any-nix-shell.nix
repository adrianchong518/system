{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils.any-nix-shell;
in
{
  options.modules.shell.utils.any-nix-shell = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    hm.home.packages = [ pkgs.any-nix-shell ];

    modules.shell.fish.extraInit = ''
      any-nix-shell fish --info-right | source
    '';
  };
}
