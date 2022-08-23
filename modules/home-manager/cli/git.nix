{ config, lib, pkgs, ... }:

{
  home.shellAliases = {
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
    gap = "git add -p";
    gc = "git commit";
    gcm = "git commit -m";
    gcl = "git clone";
    gb = "git branch";
    gco = "git checkout";
    gs = "git stash";
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
    };
  };
}
