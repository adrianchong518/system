{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  inherit (pkgs.stdenvNoCC) isDarwin;

  cfg = config.modules.shell.git;
in
{
  options.modules.shell.git = with types; {
    enable = mkBoolOpt true;
    lazygit.enable = mkBoolOpt false;

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

        extraConfig = {
          init.defaultBranch = "main";

          credential.helper =
            if isDarwin then "osxkeychain"
            else "${ pkgs.git.override { withLibsecret = true; } }/bin/git-credential-libsecret";
        };

        aliases = {
          fix = "commit --amend --no-edit";
          oops = "reset HEAD~1";
          clone-worktree = "!sh ${./git-clone-for-worktree.sh}";
        };

        signing = mkIf cfg.signing.enable {
          signByDefault = true;
          key = cfg.signing.key;
        };
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
      ga = "git add";
      gaa = "git add --all";
      gap = "git add -p";
      gb = "git branch";
      gc = "git commit";
      gcam = "git commit -am";
      gcl = "git clone --recursive";
      gclw = "git clone-worktree";
      gcm = "git commit -m";
      gco = "git checkout";
      gd = "git diff";
      gf = "git fetch";
      gp = "git push";
      gpl = "git pull";
      gs = "git stash";
      gst = "git status";
      gw = "git worktree";

      lg = "lazygit";
    };
  };
}
