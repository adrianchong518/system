{ inputs, lib, ... }:

let
  inherit (lib.my) mapListToAttrs mkNixosHost;
in
mapListToAttrs mkNixosHost [
  { path = ./hiatus; }
  { path = ./howling; system = "aarch64-linux"; }
]
