{ flake, inputs, config, pkgs, lib, ... }:

let nixpkgsConfigFile = ./_nixpkgs-config.nix;
in {
  nixpkgs = {
    config = import nixpkgsConfigFile // {
      packageOverrides = p: {
        libinput = pkgs.my.libinput;
      };
    };
    overlays = import "${flake}/overlays" { inherit flake inputs lib; };
  };

  files.config."nixpkgs/config.nix".source = nixpkgsConfigFile;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = false
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    nixPath = builtins.map
      (source: "${source}=/etc/${config.environment.etc.${source}.target}") [
      "home-manager"
      "nixpkgs"
      "stable"
    ];

    settings = {
      auto-optimise-store = true;

      trusted-users = [ "${config.my.user.name}" "root" "@admin" "@wheel" ];

      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://ros.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
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
        flake = inputs.nixpkgs-stable;
      };

      unstable = {
        from = {
          id = "unstable";
          type = "indirect";
        };
        flake = inputs.nixpkgs-unstable;
      };
    };
  };

}
