{ inputs, lib, ... }:

# expose other channels via overlays
(final: prev: {
  # XXX: broken? with stdenv and config.replaceStdenv being null?
  # stable = import inputs.nixpkgs-stable { inherit (prev) system config; };
  unstable = import inputs.nixpkgs-unstable { inherit (prev) system config; };
})
