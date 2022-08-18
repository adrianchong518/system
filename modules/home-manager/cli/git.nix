{ config, lib, pkgs, ... }:

{
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
