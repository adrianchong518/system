{ config, lib, pkgs, ... }:

{
  programs.password-store.enable = true;
  services.pass-secret-service.enable = true;

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
