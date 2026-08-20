{ inputs, pkgs, lib, config, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.utils.otter-launcher;
in
{
  options.modules.nixos.desktop.utils.otter-launcher = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [
      inputs.otter-launcher.packages.${pkgs.stdenv.hostPlatform.system}.otter-launcher

      fsel
      bluetui
      wiremix
    ];

    files.config."otter-launcher/config.toml".source = ./config.toml;
  };
}
