{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.jujutsu;
  gitCfg = config.modules.shell.git;
in
{
  options.modules.shell.jujutsu = with types; {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    modules.shell.git.enable = true;

    hm.programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = gitCfg.userName;
          email = gitCfg.userEmail;
        };

        ui = {
          log-word-wrap = true;
        };

        signing = mkIf gitCfg.signing.enable {
          sign-all = true;
          backend = "gpg";
          key = gitCfg.signing.key;
        };

        core.fsmonitor = "watchman";

        aliases = {
          br-up = [ "branch" "set" "-r" "@-" ];
        };
      };
    };

    packages = [ pkgs.watchman ];

    modules.shell.fish.extraInit = /* fish */ ''
      jj util completion fish | source
    '';
  };
}

