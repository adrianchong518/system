{ inputs
, meson
, ninja
, git
, pkg-config
, wayland
, wayland-scanner
, sqlite
, xxhash
, stdenv
, ...
}:

stdenv.mkDerivation {
  pname = "cclip";
  version = inputs.cclip.shortRev;

  src = inputs.cclip;

  nativeBuildInputs = [
    meson
    ninja
    git
    pkg-config
  ];

  buildInputs = [
    wayland
    wayland-scanner
    sqlite
    xxhash
  ];
}
