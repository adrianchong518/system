{ inputs, lib, ... }:

# expose other channels via overlays
(final: prev: {
  stable = import inputs.stable { system = prev.system; };
})
