{ config, ... }:

{
  hm.xdg.enable = true;

  env.XDG_BIN_HOME = "$HOME/.local/bin";
}
