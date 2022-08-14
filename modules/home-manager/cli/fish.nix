{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "darcula";
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "fish";
          rev = "610147cc384ff161fbabb9a9ebfd22b743f82b67";
          sha256 = "0pf65j87pgf2z3818lbijqnffam319x0gzll4v3hfiws04c08b2v";
        };
      }
      {
        name = "puffer-fish";
        src = pkgs.fetchFromGitHub {
          owner = "nickeb96";
          repo = "puffer-fish";
          rev = "f8df25bde0875359805967aa999744a28dee0561";
          sha256 = "0pbqswjl22yfjdj6yhz32n2kw0djhlr0swdxiji6vp7ljyghhvhs";
        };
      }
      { name = "foreign-env"; src = pkgs.fishPlugins.foreign-env.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];

    functions = {
      fish_greeting.body = "";
    };

    shellInit = ''
      ${lib.optionalString pkgs.stdenvNoCC.isDarwin ''
        test -e /opt/homebrew \
          && eval (/opt/homebrew/bin/brew shellenv)
      ''}
      # see https://github.com/LnL7/nix-darwin/issues/122
      fish_add_path --move --prepend --path "$HOME/.cabal/bin" "$HOME/.ghcup/bin" $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

      # vulkan SDK
      test -e $HOME/VulkanSDK/1.3.211.0/setup-env.sh \
        && fenv source $HOME/VulkanSDK/1.3.211.0/setup-env.sh
    '';

    interactiveShellInit = ''
      # grc
      test -e $HOME/.nix-profile/etc/grc.fish \
        && source $HOME/.nix-profile/etc/grc.fish

      # any-nix-shell
      any-nix-shell fish --info-right | source
    '';
  };
}
