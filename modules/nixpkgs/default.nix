{ flake, inputs, config, pkgs, lib, ... }:

let
  nixpkgsConfigFile = ./_nixpkgs-config.nix;
in
{
  nixpkgs = {
    config = import nixpkgsConfigFile;
    overlays = import "${flake}/overlays" { inherit inputs lib; };
  };

  hm.nixpkgs.config = import nixpkgsConfigFile;
  files.config."nixpkgs/config.nix".source = nixpkgsConfigFile;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    readOnlyStore = true;
    nixPath = builtins.map
      (source: "${source}=/etc/${config.environment.etc.${source}.target}") [
      "home-manager"
      "nixpkgs"
      "stable"
    ];

    settings = {
      trusted-users = [ "${config.user.name}" "root" "@admin" "@wheel" ];
      max-jobs = 8;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = inputs.nixpkgs;
      };

      stable = {
        from = {
          id = "stable";
          type = "indirect";
        };
        flake = inputs.stable;
      };
    };
  };

}
