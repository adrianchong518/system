{ config, lib, pkgs, ... }:

{
  imports = [
    ./kakoune
    ./fish.nix
    ./git.nix
  ];

  home.shellAliases =
  let
    ls-base = "exa --group-directories-first --color=always";
  in
  rec {
    # exa
    l = "${ls-base} -l";
    ls = "${l}";
    la = "${ls-base} -la";
    t = "${ls-base} -T";
    lt = "${ls-base} -lT";
    ta = "${ls-base} -aT";
    lta = "${ls-base} -laT";

    # git
    g = "git";
    gp = "git push";
    gpo = "git push origin";
    gpl = "git pull";
    gplo = "git pull origin";
    gf = "git fetch";
    gst = "git status";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gcm = "git commit -m";
    gcam = "git commit -am";
    gcl = "git clone";
    gb = "git branch";
    gco = "git checkout";
  } // lib.optionalAttrs pkgs.stdenvNoCC.isDarwin
    rec {
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
    # changeDirWidgetOptions = [ "--preview '${pkgs.tree}/bin/tree -C {} | head -200'" ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      directory.fish_style_pwd_dir_length = 1;
      status.disabled = false;
    };
  };
}
