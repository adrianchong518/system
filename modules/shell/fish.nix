{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.fish;
in
{
  options.modules.shell.fish = with types; {
    enable = mkBoolOpt false;

    package = mkOpt package pkgs.fish;

    extraInit = mkOpt' lines "" ''
      Extra shell init for fish
    '';
  };

  config = mkIf cfg.enable
    ({
      hm.programs.fish = {
        enable = true;
        package = cfg.package;

        plugins = with pkgs.fishPlugins; [
          { name = "foreign-env"; src = foreign-env.src; }
          { name = "fzf-fish"; src = fzf-fish.src; }
        ];

        functions = {
          fish_greeting.body = "";
          fish_user_key_bindings.body = "fish_vi_key_bindings";
        };

        shellInit = ''
          # see https://github.com/LnL7/nix-darwin/issues/122
          fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

          ${cfg.extraInit}
        '';
      };
    }
    // optionalAttrs (isManagedSystem hostType)
      {
        environment.shells = [ cfg.package ];
      });
}
