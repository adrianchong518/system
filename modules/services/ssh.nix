{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  inherit (pkgs.stdenvNoCC) isDarwin;

  cfg = config.modules.services.ssh;
in
{
  options.modules.services.ssh = with types; {
    enable = mkBoolOpt false;
    git = {
      enable = mkBoolOpt false;
      identityFile = mkOpt (nullOr str) null;
    };
  };

  config = mkIf cfg.enable ({
    hm = {
      programs.ssh = {
        enable = true;

        extraConfig = ''
          AddKeysToAgent yes
        '';
      } // optionalAttrs cfg.git.enable {
        matchBlocks."github.com" = {
          host = "github.com";
          identityFile = cfg.git.identityFile;
        } // optionalAttrs isDarwin {
          extraOptions = {
            UseKeychain = "yes";
            IgnoreUnknown = "UseKeychain";
          };
        };
      };

      services.ssh-agent.enable = true;
    };
  } // optionalAttrs (isNixosHost hostType) {
    services.openssh.enable = true;
    programs.ssh.startAgent = true;
  });
}
