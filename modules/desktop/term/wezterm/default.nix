{ inputs, config, options, pkgs, lib, system, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.wezterm;
in {
  options.modules.desktop.term.wezterm = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${system}.default;
      extraConfig = builtins.readFile ./config.lua;
    };
  };
}
