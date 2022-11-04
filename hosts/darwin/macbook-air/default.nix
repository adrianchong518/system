{ flake, inputs, pkgs, lib, ... }:

{
  modules = {
    darwin.homebrew.enable = true;
  };
}
