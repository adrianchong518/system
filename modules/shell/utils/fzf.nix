{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.utils.fzf;
in {
  options.modules.shell.utils.fzf = with types; {
    enable = mkBoolOpt config.modules.shell.utils.enable;
  };

  config = mkIf cfg.enable {
    hm.programs.fzf = rec {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;

      defaultCommand =
        "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude '.git' --exclude 'node_modules'";
      defaultOptions = [
        "--preview '${pkgs.bat}/bin/bat --color=always --style=changes {}' --height 50% --reverse"
      ];

      fileWidget = {
        command = "${defaultCommand}";
        options = defaultOptions;
      };

      changeDirWidget = {
        command = "${defaultCommand} --type d";
        options = [ "--preview '${config.modules.shell.aliases.ta} {}'" ];
      };
    };
  };
}
