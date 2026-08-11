{ inputs
, lib
, fetchFromGitHub
, linuxPackagesFor
, system
, ...
}:

linuxPackagesFor (inputs.nixos-apple-silicon.packages.${system}.linux-asahi.overrideAttrs (old: {
  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "linux";
    rev = "eb8089bbc11872c50fcf5138ff069d51b4ae996f";
    hash = lib.fakeHash;
  };
}))
