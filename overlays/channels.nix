{ inputs, lib, ... }:

# expose other channels via overlays
(final: prev: {
  # XXX: broken? with stdenv and config.replaceStdenv being null?
  stable = inputs.nixpkgs-stable.legacyPackages.${prev.system};
  unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
})
