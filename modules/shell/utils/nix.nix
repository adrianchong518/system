{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.utils.nix;
in {
  options.modules.shell.utils.nix = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    hm.programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    hm.programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 7d";
      };
    };

    packages = with pkgs; [
      any-nix-shell
      comma
      nix-output-monitor
    ];

    modules = {
      shell.fish.extraInit = ''
        any-nix-shell fish --info-right | source
      '';
    };
  };
}
