{ inputs, config, pkgs, lib, ... }:
let
  homeDir = config.home.homeDirectory;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
    path = "${homeDir}/.nixpkgs/modules/home-manager";
  };

  home = {
    stateVersion = "22.05";

    packages = with pkgs; [
      bat
      exa
      grc
      ripgrep
      fd
      tldr
      neofetch
      rustup
      btop
      cmake
      gcc
      bitwarden-cli
      any-nix-shell
      nixpkgs-fmt
      iosevka-bin
    ];

    sessionVariables = {
      EDITOR = "kak";
      MANPAGER = "sh -c 'col -bx | bat -l man -p --paging always'";
    };

    shellAliases = {
      # exa
      l = "exa -a --group-directories-first --color=always";
      la = "exa -la --git --group-directories-first --color=always";
      tree = "exa -T --group-directories-first --color=always";
      ltree = "exa -lT --git --group-directories-first --color=always";

      # git
      g = "git";
      gp = "git push";
      gpo = "git push origin";
      gpl = "git pull";
      gplo = "git pull origin";
      gf = "git fetch";
      gst = "git status";
      ga = "git add -u";
      gaa = "git add --all";
      gc = "git commit";
      gcm = "git commit -m";
      gcam = "git commit -am";
      gcl = "git clone";
      gb = "git branch";
      gco = "git checkout";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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
      fish_greeting = {
        description = "Greeting to show when starting a fish shell";
        body = "";
      };
    };

    shellInit = ''
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

      # haskell
      set -px PATH $HOME/.cabal/bin
      set -px PATH $HOME/.ghcup/bin

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

  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      directory.fish_style_pwd_dir_length = 1;
      status.disabled = false;
    };
  };

  programs.kakoune = {
    enable = true;

    config = {
      colorScheme = "default";

      numberLines = {
        enable = true;
        highlightCursor = true;
      };

      scrollOff = {
        lines = 5;
        columns = 10;
      };

      ui = {
        enableMouse = true;
        assistant = "none";
      };

      hooks = [
        {
          name = "WinSetOption";
          option = "filetype=markdown";
          commands = ''
            set window autowrap_column 80
            autowrap-enable

            addhl window/ column 81 default,rgb:404040
          '';
        }
        {
          name = "WinSetOption";
          option = "filetype=nix";
          commands = ''
            set window indentwidth 2
          '';
        }
      ];

      keyMappings = [
        {
          mode = "user";
          key = "w";
          effect = ":echo %sh{wc -w <lt><lt><lt> \"\${kak_selection}\"}<ret>";
          docstring = "Word count in selection";
        }
      ];
    };

    # extraConfig = ''
    #   eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
    #   lsp-enable
    # '';

    # plugins = with pkgs.kakounePlugins; [
    #     kak-lsp
    #     kak-auto-pairs
    # ];
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type f --hidden -g \"!{**/.git/*,**/node_modules/*}\"";
  };

  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.kitty = {
    enable = true;

    theme = "Ayu";

    settings = {
      font_family = "Iosevka Term";
      font_size = 14;

      window_padding_width = "1.0";

      term = "xterm-256color";

      enable_audio_bell = "no";

      confirm_os_window_close = 2;

      tab_bar_style = "slant";
      hide_window_decorations = "titlebar-only";

      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = "yes";
      macos_thicken_font = "0.5";
    };
  };

}
