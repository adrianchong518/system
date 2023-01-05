{ config, ... }:

{
  hm.xdg.enable = true;

  modules.shell.variables = {
    XDG_BIN_HOME = "$HOME/.local/bin";
  };
}
