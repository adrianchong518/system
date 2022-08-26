{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      line_break.disabled = true;
      package.disabled = true;

      status.disabled = false;
    };
  };
}
