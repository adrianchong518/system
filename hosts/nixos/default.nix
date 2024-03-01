{ inputs, lib, ... }:

let
  inherit (lib.my) mapListToAttrs mkNixosHost;
in
mapListToAttrs mkNixosHost [
  { path = ./hiatus; }
]
