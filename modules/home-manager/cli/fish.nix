{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "puffer-fish";
        src = pkgs.fetchFromGitHub {
          owner = "nickeb96";
          repo = "puffer-fish";
          rev = "f8df25bde0875359805967aa999744a28dee0561";
          hash = "sha256-Gm4In5f03G2ijL1xDTKFsgE+hRXjQ29kk84LQSXXeF0=";
        };
      }
      { name = "foreign-env"; src = pkgs.fishPlugins.foreign-env.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];

    functions = {
      fish_greeting.body = "";
      fish_user_key_bindings.body = "fish_vi_key_bindings";
    };

    shellInit = ''
      ${lib.optionalString pkgs.stdenvNoCC.isDarwin ''
        test -e /opt/homebrew \
          && eval (/opt/homebrew/bin/brew shellenv)
      ''}

      # see https://github.com/LnL7/nix-darwin/issues/122
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

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
