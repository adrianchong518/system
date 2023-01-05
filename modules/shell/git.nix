{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.git;
in
{
  options.modules.shell.git = with types; {
    enable = mkBoolOpt true;
    lazygit.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm = {
      programs.git = {
        enable = true;

        extraConfig = {
          init.defaultBranch = "main";

          credential.helper =
            if pkgs.stdenvNoCC.isDarwin then
              "osxkeychain"
            else "${ pkgs.git.override { withLibsecret = true; } }/bin/git-credential-libsecret";
        };

        aliases = {
          fix = "commit --amend --no-edit";
          oops = "reset HEAD~1";
          clone-worktree = "!sh ${./git-clone-for-worktree.sh}";
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
  };
}
