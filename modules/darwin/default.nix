{ pkgs, ... }:

{
  imports = [
    ../common.nix
    ./core.nix
    ./nixpkgs.nix
    ./brew.nix
    ./preferences.nix
    # ./display-manager.nix
  ];
}
