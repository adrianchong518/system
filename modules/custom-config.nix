{ config, pkgs, lib, ... }:

{
  options.custom = {
    isDarwin = lib.mkEnableOption "darwin";
    isNixos = lib.mkEnableOption "Nix OS";
  };
}
