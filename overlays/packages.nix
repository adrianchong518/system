{ flake, inputs, lib, ... }:

(final: prev: rec {
  my = flake.packages."${prev.system}";
  # libinput = my.libinput;
})
