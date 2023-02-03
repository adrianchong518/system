{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.darwin.desktop.de.hammerspoon;
in
{
  options.modules.darwin.desktop.de.hammerspoon = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew.casks = [ "hammerspoon" ];

    hm.home.activation.reloadHammerspoon = hm.dag.entryAfter [ "writeBoundary" ] ''
      # Reload hammerspoon config
      if ! type "/usr/local/bin/hs" > /dev/null; then
        echo >&2 "warning: hs cli not installed, config not reloaded"
      else
        /usr/local/bin/hs -c "hs.reload()"
      fi
    '';

    files.home.".hammerspoon" = {
      source = ./_config;
      recursive = true;
    };
  };
}
