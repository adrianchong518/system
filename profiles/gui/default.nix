{ config, pkgs, lib, ... }:

{
  hm = { imports = [ ../../modules/home-manager/gui ]; };
}
