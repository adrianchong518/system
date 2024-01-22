{ flake, inputs, lib, ... }:

(final: prev: {
  my = flake.packages."${prev.system}";
})
