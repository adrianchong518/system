{
  description = "adrianchong518's system configurations";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:msteen/nixos-vscode-server";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.url = "github:hyprwm/Hyprland/e7a5db4852d654596e554b9cdeaa2694b346ee03";
    hyprlock.url = "github:hyprwm/hyprlock/main";
    hypridle.url = "github:hyprwm/hypridle/main";

    wezterm.url = "github:wez/wezterm?dir=nix";
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
          pyEnv = (pkgs.python3.withPackages
            (ps: with ps; [ typer ])); #[ black colorama shellingham ]));
          sysdo = pkgs.writeShellScriptBin "sysdo" ''
            cd $PRJ_ROOT && ${pyEnv}/bin/python3 bin/do.py $@
          '';
        in
        {
          default = pkgs.devshell.mkShell {
            packages = with pkgs; [
              pyEnv
              nil
              lua-language-server
              treefmt
              stylua
              nixpkgs-fmt
            ];
            commands = [{
              name = "sysdo";
              package = sysdo;
              category = "utilities";
              help = "perform actions on this repository";
            }];
          };
        }
      );
    };
}
