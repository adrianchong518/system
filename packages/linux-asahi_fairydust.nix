{ inputs
, fetchFromGitHub
, linuxPackagesFor
, system
, ...
}:

linuxPackagesFor (inputs.nixos-apple-silicon.packages.${system}.linux-asahi.overrideAttrs (old: {
  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "linux";
    rev = "b0b5bbf9f67e9063af591e7a1187d37d0f2b8e29";
    hash = "sha256-CWKAyyGuu9jjcwN3Gz98ZjcTLRPQwnpKd32IyD4zsBw=";
  };
}))
