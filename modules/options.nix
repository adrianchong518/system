{ config, options, pkgs, lib, hostType, ... }:

with lib;
with lib.my;
let inherit (pkgs.stdenvNoCC) isDarwin;
in {
  options = with types; {
    hm = mkOpt attrs { };
    my.user = mkOpt attrs { };

    packages = mkOpt (listOf package) [ ];
    env = mkOpt (lazyAttrsOf (oneOf [ str path int float ])) { };
  };

  config = {
    hm.home = {
      stateVersion = "23.05";
      packages = mkAliasDefinitions options.packages;
      sessionVariables = mkAliasDefinitions options.env;
    };

    my.user =
      let
        user = builtins.getEnv "USER";
        name = if elem user [ "" "root" ] then "adrianchong" else user;
        homePrefix = if isDarwin then "/Users" else "/home";
      in
      {
        inherit name;
        description = "Adrian Chong";
        home = "${homePrefix}/${name}";
      };
  } // optionalAttrs (isManagedSystem hostType) {
    # set up primary user
    # hm -> home-manager.users.<primary user>
    home-manager.users.${config.my.user.name} = mkAliasDefinitions options.hm;
    # user -> users.users.<primary user>
    users.users.${config.my.user.name} = mkAliasDefinitions options.my.user;
  } // optionalAttrs (isHmHost hostType) ({
    home = {
      username = config.my.user.name;
      homeDirectory = config.my.user.home;
    };
  } // config.hm);
}
