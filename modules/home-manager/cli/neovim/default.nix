{ config, pkgs, lib, ... }:

rec {
  imports = [
    ./plugins
  ];

  lib.vimUtils = rec {
    wrapLuaConfig = luaConfig: ''
      lua<<EOF
      ${luaConfig}
      EOF
    '';
    readConfig = file:
      if (pkgs.lib.strings.hasSuffix ".lua" (builtins.toString file)) then
        wrapLuaConfig (builtins.readFile file) else
        builtins.readFile file;
    pluginWithConfig = { plugin, config, extraConfig ? "" }: {
      inherit plugin;
      config = readConfig config + extraConfig;
    };
  };

  home.shellAliases = {
    v = "nvim";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      ${lib.vimUtils.readConfig ./settings.lua}
      ${lib.vimUtils.readConfig ./keymaps.lua}
    '';
  };
}
