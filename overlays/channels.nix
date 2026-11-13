{ inputs, lib, ... }:

# expose other channels via overlays
(final: prev: {
  stable = inputs.nixpkgs-stable.legacyPackages.${prev.system};
  unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
})
