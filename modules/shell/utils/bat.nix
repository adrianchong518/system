{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils.bat;

  catppuccinThemeSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "b19bea35a85a32294ac4732cad5b0dc6495bed32";
    sha256 = "POoW2sEM6jiymbb+W/9DKIjDM1Buu1HAmrNP0yC2JPg=";
  };
in
{
  options.modules.shell.utils.bat = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    hm.programs.bat = {
      enable = true;

      config = {
        theme = "catppuccin-mocha";
      };

      themes = {
        catppuccin-latte = { src = catppuccinThemeSrc; file = "themes/Catppuccin Latte.tmTheme"; };
        catppuccin-frappe = { src = catppuccinThemeSrc; file = "themes/Catppuccin Frappe.tmTheme"; };
        catppuccin-macchiato = { src = catppuccinThemeSrc; file = "themes/Catppuccin Macchiato.tmTheme"; };
        catppuccin-mocha = { src = catppuccinThemeSrc; file = "themes/Catppuccin Mocha.tmTheme"; };
      };
    };

    env = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      BAT_PAGER = "${pkgs.less}/bin/less -RF";
    };
  };
}
