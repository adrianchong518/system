{ config, inputs, lib, hostType, ... }:

with lib;
with lib.my;
let cfg = config.modules;
in {
  imports = importModulesRec ./.
    ++ optional (isManagedSystem hostType) ./_managed
    ++ optional (isDarwinHost hostType) ./_darwin
    ++ optional (isNixosHost hostType) ./_nixos;

  assertions = [{
    assertion = cfg.desktop.enable
      || (all (mod: anyAttrs' (n: v: !(n == "enable" && isBool v && v)) mod)
      ([ cfg.desktop ]
        ++ optional (isManagedSystem hostType) cfg.managed.desktop
        ++ optional (isDarwinHost hostType) cfg.darwin.desktop
        ++ optional (isNixosHost hostType) cfg.nixos.desktop));

    message = "Cannot enable desktop apps without a enabling desktop";
  }];

  hm.catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };
}
