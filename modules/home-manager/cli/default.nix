{ config, lib, pkgs, ... }:

let
  lsBase = "${pkgs.exa}/bin/exa --group-directories-first --color=always --icons --git";
  treeBase = "${lsBase} --git-ignore";
  exaAliases = rec {
    l = "${lsBase} -l";
    ls = "${l}";
    la = "${lsBase} -la";
    t = "${treeBase} -T";
    lt = "${treeBase} -lT";
    ta = "${treeBase} -aT";
    lta = "${treeBase} -laT";
  };
in
{
  imports = [
    ./kakoune
    ./neovim
    ./git

    ./fish.nix
    ./starship.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    # standard toolset
    coreutils-full
    curl
    wget
    git
    jq

    # helpful shell stuff
    bat
    fzf
    ripgrep
    fd
    grc
    tldr
    neofetch
    btop
    bitwarden-cli

    # helpful nix tools
    any-nix-shell
    comma
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

    defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude '.git' --exclude 'node_modules'";
    defaultOptions = [ "--preview '${pkgs.bat}/bin/bat --color=always --style=changes {}' --height 50% --reverse" ];
    fileWidgetCommand = "${defaultCommand}";
    fileWidgetOptions = defaultOptions;
    changeDirWidgetCommand = "${defaultCommand} --type d";
    changeDirWidgetOptions = [ "--preview '${exaAliases.ta} {}'" ];
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
