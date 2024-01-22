{ inputs, pkgs, lib, ... }:

with lib;
with lib.my; {
  imports = importModulesRec ./.;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # environment setup
  environment.etc = {
    home-manager.source = "${inputs.home-manager}";
    nixpkgs.source = "${pkgs.path}";
    stable.source = "${inputs.nixpkgs-stable}";
    unstable.source = "${inputs.nixpkgs-unstable}";
  };
}
