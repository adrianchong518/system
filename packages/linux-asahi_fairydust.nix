{ lib
, callPackage
, linuxPackagesFor
, _kernelPatches ? [ ]
, ...
}@args:

let
  extraArgs = lib.removeAttrs args [
    "lib"
    "callPackage"
    "linuxPackagesFor"
    "_kernelPatches"
  ];

  linux-asahi-pkg =
    { stdenv
    , lib
    , fetchFromGitHub
    , buildLinux
    , ...
    }:
    buildLinux (
      lib.recursiveUpdate
        rec {
          inherit stdenv lib;

          pname = "linux-asahi";
          version = "7.1.6";
          modDirVersion = version;
          extraMeta.branch = "7.1";

          src = fetchFromGitHub {
            owner = "AsahiLinux";
            repo = "linux";
            rev = "eb8089bbc11872c50fcf5138ff069d51b4ae996f";
            hash = "sha256-WywkNZXonLcyO0xAMlW7/k3uE9Embz3qedwyB5VOxQs=";
          };

          kernelPatches = [
            {
              name = "Asahi config";
              patch = null;
              structuredExtraConfig = with lib.kernel; {
                # Needed for GPU
                ARM64_16K_PAGES = yes;

                ARM64_MEMORY_MODEL_CONTROL = yes;
                ARM64_ACTLR_STATE = yes;

                # Might lead to the machine rebooting if not loaded soon enough
                APPLE_WATCHDOG = yes;

                # Can not be built as a module, defaults to no
                APPLE_M1_CPU_PMU = yes;

                # Defaults to 'y', but we want to allow the user to set options in modprobe.d
                HID_APPLE = module;

                APPLE_PMGR_MISC = yes;
                APPLE_PMGR_PWRSTATE = yes;
              };
              features.rust = true;
            }
          ]
          ++ _kernelPatches;
        }
        extraArgs
    );

  linux-asahi = callPackage linux-asahi-pkg { };
in
lib.recurseIntoAttrs (linuxPackagesFor linux-asahi)
