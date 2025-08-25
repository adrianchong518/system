{ libinput, ... }:
libinput.overrideAttrs (old: {
  __intentionallyOverridingVersion = true;
  version = old.version + "-v120";
  patches = (old.patches or [ ]) ++ [ ./acc_v120_threshold.patch ];
})
