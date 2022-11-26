{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.utils;
in
{
  options.modules.shell.utils = with types; {
    enable = mkBoolOpt false;
  };
}
