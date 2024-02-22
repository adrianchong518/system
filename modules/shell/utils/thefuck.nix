{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.utils.thefuck;
in {
  options.modules.shell.utils.thefuck = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    hm.programs.thefuck.enable = true;
    files.config."thefuck/settings.py".text = /* python */ ''
      exclude_rules = [
        "fix_file",
        "nixos_cmd_not_found",
      ]
    '';
  };
}
