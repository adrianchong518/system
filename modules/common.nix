{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./primary.nix
    ./nixpkgs.nix
    ./overlays.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };
  programs.fish.enable = true;

  user = {
    description = "Adrian Chong";
    home = "${
      if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
    shell = pkgs.fish;
  };

  # bootstrap home manager using system config
  hm = import ./home-manager;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # environment setup
  environment = {
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${pkgs.path}";
      stable.source = "${inputs.stable}";
    };

    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bash zsh fish ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      iosevka-bin
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
  };
}
