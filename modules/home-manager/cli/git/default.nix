{ config, lib, pkgs, ... }:

{
  home.shellAliases = {
    cdr = "cd $(git rev-parse --show-toplevel)";

    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gap = "git add -p";
    gb = "git branch";
    gc = "git commit";
    gcam = "git commit -am";
    gcl = "git clone";
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

  programs.git = {
    enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper =
        if pkgs.stdenvNoCC.isDarwin then
          "osxkeychain"
        else "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };

    aliases = {
      fix = "commit --amend --no-edit";
      oops = "reset HEAD~1";
      clone-worktree = "!sh ${./git-clone-for-worktree.sh}";
    };
  };

  programs.lazygit = {
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
}
