{ inputs, lib, ... }:

# expose other channels via overlays
(final: prev: {
  stable = import inputs.nixpkgs-stable { inherit (prev) system config; };
  unstable = import inputs.nixpkgs-unstable { inherit (prev) system config; };
})
