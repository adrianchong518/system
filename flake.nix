{
  description = "adrianchong518's system configurations";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-22.11";

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

    lunarvim = {
      url = "github:LunarVim/LunarVim";
      flake = false;
    };

    # vimPlugins
    centerpad-nvim = { url = "github:smithbm2316/centerpad.nvim"; flake = false; };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, flake-utils, ... }:
    let
      inherit (flake-utils.lib) eachDefaultSystemMap;

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

      darwinConfigurations = import ./hosts/darwin { inherit inputs lib; };

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
              nixfmt
              pyEnv
              nil
              sumneko-lua-language-server
              treefmt
              stylua
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
