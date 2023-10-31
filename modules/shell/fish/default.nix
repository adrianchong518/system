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

        interactiveShellInit = ''
          # Emulates vim's cursor shape behavior
          # Set the normal and visual mode cursors to a block
          set fish_cursor_default block
          # Set the insert mode cursor to a line
          set fish_cursor_insert line
          # Set the replace mode cursor to an underscore
          set fish_cursor_replace_one underscore
        '';
      };

      files.config."fish/themes/catppuccin-mocha.theme".source = ./catppuccin-mocha.theme;
    }
    // optionalAttrs (isManagedSystem hostType)
      {
        programs.fish.enable = true;
        environment.shells = [ cfg.package ];
      });
}
