{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.darwin.desktop.de.hammerspoon;
in {
  options.modules.darwin.desktop.de.hammerspoon = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    homebrew.casks = [ "hammerspoon" ];

    packages = with pkgs; [ lua54Packages.fennel ];

    hm.home.activation.reloadHammerspoon =
      hm.dag.entryAfter [ "writeBoundary" ] ''
        # Reload hammerspoon config
        if ! type "/usr/local/bin/hs" > /dev/null; then
          echo >&2 "warning: hs cli not installed, config not reloaded"
        else
          /usr/local/bin/hs -c "hs.reload()"
        fi
      '';

    files = {
      home.".hammerspoon/init.lua".text = ''
        -- Set the config directory
        configdir = "${./_config}"

        -- Nix-managed modules
        package.path = package.path .. ";${pkgs.lua54Packages.fennel}/share/lua/5.4/?.lua"
        package.path = package.path .. ";${./_config}/?/init.lua"
        package.path = package.path .. ";${./_config}/?.lua"

        -- Fennel setup
        fennel = require "fennel"
        fennel.path = fennel.path .. ";${./_config}/?.fnl"
        fennel.path = fennel.path .. ";${./_config}/?/init.fnl"
        fennel["macro-path"] = fennel["macro-path"] .. ";${./_config}/?.fnl"
        fennel["macro-path"] = fennel["macro-path"] .. ";${
          ./_config
        }/?/init.fnl"
        debug.traceback = fennel.traceback
        table.insert(package.loaders or package.searchers, fennel.searcher)

        -- Load the config
        require "core"
      '';
    };
  };
}
