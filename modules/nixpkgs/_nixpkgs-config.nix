{
  allowUnsupportedSystem = true;
  allowUnfree = true;
  allowBroken = false;
  nvidia.acceptLicense = true;
  permittedInsecurePackages = [
    "electron-39.8.10" # XXX: bitwarden desktop
    "electron-40.10.5" # XXX: winboat
  ];
}

