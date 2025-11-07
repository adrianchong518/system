{
  description = "adrianchong518's system configurations";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nur.url = "github:nix-community/NUR";

    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:msteen/nixos-vscode-server";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    remote-nvim = { url = "github:amitds1997/remote-nvim.nvim"; flake = false; };

    waybar-mpris = { url = "git+https://git.yaroslavps.com/waybar-mpris"; flake = false; };

    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-howdy.url = "github:fufexan/nixpkgs/howdy";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, flake-utils, ... }:
    let
      inherit (flake-utils.lib) eachDefaultSystemMap;
      inherit (lib.my) mapModules;

      flake = self;

      lib = nixpkgs.lib.extend
        (self: super: {
          my = import ./lib {
            inherit flake inputs;
            lib = self;
          };
          hm = home-manager.lib.hm;
        });
    in
    {
      lib = lib.my;

      packages = eachDefaultSystemMap (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = import ./modules/nixpkgs/_nixpkgs-config.nix;
            overlays = [ (import ./overlays/cuda.nix { }) ]; # XXX: cuda causes issues
          };
        in
        (mapModules (p: pkgs.callPackage p { inherit inputs system; }) ./packages)
      );

      darwinConfigurations = import ./hosts/darwin { inherit inputs lib; };
      nixosConfigurations = import ./hosts/nixos { inherit inputs lib; };

      devShells = eachDefaultSystemMap (system:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ inputs.devshell.overlays.default ];
          };
        in
        {
          default = pkgs.devshell.mkShell {
            packages = with pkgs; [
              nil
              lua-language-server
              treefmt
              stylua
              nixpkgs-fmt
              just
            ];
          };
        }
      );
    };
}
