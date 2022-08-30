{ config, lib, pkgs, ... }:

let
  lsBase = "${pkgs.exa}/bin/exa --group-directories-first --color=always --icons --git";
  exaAliases = rec {
    l = "${lsBase} -l";
    ls = "${l}";
    la = "${lsBase} -la";
    t = "${lsBase} -T";
    lt = "${lsBase} -lT";
    ta = "${lsBase} -aT";
    lta = "${lsBase} -laT";
  };
in
{
  imports = [
    ./kakoune
    ./fish.nix
    ./git.nix
    ./starship.nix
  ];

  home.shellAliases =
    exaAliases
    // lib.optionalAttrs pkgs.stdenvNoCC.isDarwin
      {
        # darwin specific aliases
        ibrew = "arch -x86_64 brew";
        abrew = "arch -arm64 brew";
      };

  programs.ssh.enable = true;

  programs.exa.enable = true;
  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = rec {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    defaultCommand = "fd --type f --hidden -g \"!{**/.git/*,**/node_modules/*}\"";
    defaultOptions = [ "--height 50%" ];
    fileWidgetCommand = "${defaultCommand}";
    fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat --color=always --plain --line-range=:200 {}'" ];
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
  };
}
