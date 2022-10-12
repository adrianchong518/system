{ inputs, lib, ... }:

let
  inherit (lib.my) mapListToAttrs mkDarwinHost;
in
mapListToAttrs mkDarwinHost [
  { path = ./macbook-air; }
]
