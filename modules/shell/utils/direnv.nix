{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils.direnv;
in
{
  options.modules.shell.utils.direnv = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    hm.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
