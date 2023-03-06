{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell;
in
{
  options.modules.shell = with types; {
    aliases = mkOpt (attrsOf str) { };

    default = mkOpt package pkgs.bash;

    extraPath = mkOpt (listOf str) [ ];

    rcInit = mkOpt' lines "" ''
      Extra shell init lines to be written to $XDG_CONFIG_HOME/shell/rc.sh
      This should be kept POSIX compliant
    '';

    envInit = mkOpt' lines "" ''
      Extra shell env init lines to be written to $XDG_CONFIG_HOME/shell/env.sh
      This should be kept POSIX compliant
    '';

    rcFiles = mkOpt (listOf (either str path)) [ ];
    envFiles = mkOpt (listOf (either str path)) [ ];
  };

  config = {
    hm.home = {
      shellAliases = mkAliasDefinitions options.modules.shell.aliases;
      sessionPath = mkAliasDefinitions options.modules.shell.extraPath;
    };

    user.shell = cfg.default;

    files.config = {
      "shell/rc_init.sh".text = ''
        # This file was autogenerated, do not edit it!
        ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
        ${cfg.rcInit}
      '';

      "shell/env_init.sh".text = ''
        # This file is autogenerated, do not edit it!
        ${concatMapStrings (path: "source '${path}'\n") cfg.envFiles}
        ${cfg.envInit}
      '';
    };

    modules.shell.fish.extraInit = ''
      fenv source $XDG_CONFIG_HOME/shell/env_init.sh
      fenv source $XDG_CONFIG_HOME/shell/rc_init.sh
    '';
  }
  // optionalAttrs (isManagedSystem hostType) {
    environment.shells = [ cfg.default ];
  }
  // optionalAttrs (isNixosHost hostType) {
    users.defaultUserShell = cfg.default;
  };
}
