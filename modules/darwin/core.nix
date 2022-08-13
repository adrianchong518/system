{ inputs, config, pkgs, lib, ... }:
let
  prefix = "/run/current-system/sw/bin";
  inherit (pkgs.stdenvNoCC) isAarch64 isAarch32;
in
{
  # environment setup
  environment = {
    loginShell = pkgs.fish;
    etc = {
      darwin.source = "${inputs.darwin}";
    };
  };

  homebrew.brewPrefix = if isAarch64 || isAarch32 then "/opt/homebrew/bin" else "/usr/local/bin";

  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # auto manage nixbld users with nix darwin
  users.nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
}
