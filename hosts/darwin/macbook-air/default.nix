{ flake, inputs, pkgs, lib, ... }:

{
  modules = {
    darwin.homebrew.enable = true;

    desktop.enable = true;

    shell = {
      fish.enable = true;
      starship.enable = true;
      utils.enable = true;
    };
  };
}
