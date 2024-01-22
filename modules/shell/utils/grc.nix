{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.utils.grc;
in {
  options.modules.shell.utils.grc = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    packages = [ pkgs.grc ];

    modules.shell.fish.extraInit = ''
      source "${pkgs.grc}/etc/grc.fish"
    '';
  };
}
