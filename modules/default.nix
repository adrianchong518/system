{ lib, ... }:

with lib;
with lib.my;
{
  imports = mapModulesListRec import ./.;
}
