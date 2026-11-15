{ inputs, ... }:

# expose other channels via overlays
(final: prev: {
  stable = import inputs.nixpkgs-stable {
    system = prev.stdenv.hostPlatform.system;
    config = import ../modules/nixpkgs/_nixpkgs-config.nix;
  };
  unstable = import inputs.nixpkgs-unstable {
    system = prev.stdenv.hostPlatform.system;
    config = import ../modules/nixpkgs/_nixpkgs-config.nix;
  };
})
