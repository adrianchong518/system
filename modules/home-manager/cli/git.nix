{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;

    extraConfig = {
      init.defaultBranch = "main";
    };

    aliases = {
      fix = "commit --amend --no-edit";
      oops = "reset HEAD~1";
    };
  };
}
