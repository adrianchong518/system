{ inputs, config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let
  isManagedSystem = isDarwinHost hostType || isNixosHost hostType;
in
{
  options = with types; {
    hm = mkOpt attrs { };
  }
  // optionalAttrs isManagedSystem {
    user = mkOpt attrs { };
  };

  config = {
    hm.home.stateVersion = "22.11";
  }
  // optionalAttrs isManagedSystem {
    user = {
      name = "adrianchong";
    };

    # hm -> home-manager.users.<primary user>
    home-manager.users.${config.user.name} = mkAliasDefinitions options.hm;
    # user -> users.users.<primary user>
    users.users.${config.user.name} = mkAliasDefinitions options.user;
  }
  // optionalAttrs (isLinuxHost hostType) config.hm;
}
