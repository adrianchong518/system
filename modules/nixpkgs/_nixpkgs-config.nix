{
  allowUnsupportedSystem = true;
  allowUnfree = true;
  allowBroken = false;
  nvidia.acceptLicense = true;
  permittedInsecurePackages = [
    "electron-40.10.5" # XXX: winboat
    "firefox-esr-140-bin-unwrapped-140.17.0esr" # XXX: zotero
  ];
}

