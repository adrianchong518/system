{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
{
  options = with types; {
    hm = mkOpt attrs { };
    user = mkOpt attrs { };

    modules.packages = mkOpt (listOf package) [ ];
  };

  config = {
    hm.home = {
      stateVersion = "22.11";
      packages = mkAliasDefinitions options.modules.packages;
    };

    user =
      let
        user = builtins.getEnv "USER";
        name = if elem user [ "" "root" ] then "adrianchong" else user;
        homePrefix = if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home";
      in
      {
        inherit name;
        description = "Adrian Chong";
        home = "${homePrefix}/${name}";
      };
  }
  // optionalAttrs (isManagedSystem hostType) {
    # set up primary user
    # hm -> home-manager.users.<primary user>
    home-manager.users.${config.user.name} = mkAliasDefinitions options.hm;
    # user -> users.users.<primary user>
    users.users.${config.user.name} = mkAliasDefinitions options.user;
  }
  // optionalAttrs (isHmHost hostType) (
    {
      home = {
        username = config.user.name;
        homeDirectory = config.user.home;
      };
    }
    // config.hm
  );
}
