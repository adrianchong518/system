{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  inherit (pkgs.stdenvNoCC) isDarwin;

  cfg = config.modules.shell.git;

  catppuccinDeltaThemeSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "delta";
    rev = "21b37ac3138268d92cee71dfc8539d134817580a";
    sha256 = "0QQLkfLBVuB2re6tjtPNuOQZNK0MDBAIFgNGHZM8afs=";
  };
in
{
  options.modules.shell.git = with types; {
    enable = mkBoolOpt true;
    lazygit.enable = mkBoolOpt false;
    gh.enable = mkBoolOpt false;

    enableShellAliases = mkBoolOpt true;

    userName = mkOpt str "Adrian Chong";
    userEmail = mkOpt str "adrianchong518@gmail.com";

    signing = {
      enable = mkBoolOpt false;
      key = mkOpt (nullOr str) null;
    };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.git = {
        enable = true;

        userName = cfg.userName;
        userEmail = cfg.userEmail;

        includes = [
          { path = "${catppuccinDeltaThemeSrc}/themes/latte.gitconfig"; }
          { path = "${catppuccinDeltaThemeSrc}/themes/frappe.gitconfig"; }
          { path = "${catppuccinDeltaThemeSrc}/themes/macchiato.gitconfig"; }
          { path = "${catppuccinDeltaThemeSrc}/themes/mocha.gitconfig"; }
        ];

        extraConfig = {
          core = {
            untrackedcache = true;
            fsmonitor = true;
          };

          init.defaultBranch = "main";

          credential.helper =
            if isDarwin then
              "osxkeychain"
            else
              "${
              pkgs.git.override { withLibsecret = true; }
            }/bin/git-credential-libsecret";

          fetch = {
            parallel = 0;
            writeCommitGraph = true;
          };

          pull = {
            rebase = true;
          };

          push = {
            autoSetupRemote = false;
          };

          submodule = {
            fetchJobs = 0;
            recurse = true;
          };

          rerere.enabled = true;

          column.ui = "auto";
          branch.sort = "-committerdate";
        };

        aliases = {
          fix = "commit --amend --no-edit";
          oops = "reset HEAD~1";
          clone-worktree = "!sh ${./git-clone-for-worktree.sh}";

          a = "add";
          aa = "add --all";
          ap = "add -p";
          b = "branch";
          c = "commit";
          cam = "commit -am";
          cl = "clone --recurse-submodules";
          clw = "clone-worktree";
          cm = "commit -m";
          co = "checkout";
          d = "diff";
          f = "fetch";
          l = "log --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)%ar%C(reset) %C(dim cyan)%aD%C(reset)%C(auto)%d%C(reset)%n''          %C(default)%s%C(reset) %C(dim white)- %an%C(reset)'";
          lg = "l --graph";
          p = "push";
          pl = "pull";
          s = "stash";
          st = "status";
          w = "worktree";
        };

        signing = mkIf cfg.signing.enable {
          signByDefault = true;
          key = cfg.signing.key;
        };

        delta = {
          enable = true;
          options = {
            dark = true;
            side-by-side = true;
            navigate = true;
            features = "catppuccin-mocha";
          } // optionalAttrs config.modules.shell.utils.bat.enable {
            syntax-theme = "catppuccin-mocha";
          };
        };
      };

      programs.gh = mkIf cfg.gh.enable {
        enable = true;
      };

      programs.lazygit = mkIf cfg.lazygit.enable {
        enable = true;
        settings = {
          gui = {
            theme = {
              selectedLineBgColor = [ "default" ];
              selectedRangeBgColor = [ "default" ];
            };
            showIcons = true;
          };
        };
      };
    };

    modules.shell.aliases = mkIf cfg.enableShellAliases {
      cdr = "cd $(git rev-parse --show-toplevel)";

      g = "git";
      lg = mkIf cfg.lazygit.enable "lazygit";
    };

    modules.services.gpg.enable = cfg.signing.enable;

    env.DELTA_PAGER = "${pkgs.less}/bin/less -RF";
  };
}
