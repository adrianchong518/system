{ flake, inputs, lib, ... }:

let
  inherit (lib.my) mapModulesList;
in
mapModulesList (path: import path { inherit flake inputs lib; }) ./.
