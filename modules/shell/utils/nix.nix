{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils.nix;
in
{
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

    modules = {
      packages = with pkgs; [
        any-nix-shell
        comma
      ];

      shell.fish.extraInit = ''
        any-nix-shell fish --info-right | source
      '';
    };
  };
}
