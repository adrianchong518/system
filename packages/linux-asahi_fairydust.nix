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
    rev = "4e84610e5722c34e48fef3f33f7bd8faedb13348";
    hash = "sha256-G32SzJW1paAUaBCnw5cou20WwpuVR8OZSDRpV58IUJU=";
  };
}))
