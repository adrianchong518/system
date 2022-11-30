{ config, pkgs, lib, ... }:

rec {
  imports = [
    ./plugins
  ];

  lib.vimUtils = rec {
    # For plugins configured with lua
    wrapLuaConfig = luaConfig: ''
      lua<<EOF
      ${luaConfig}
      EOF
    '';
    readVimConfigRaw = file:
      if (pkgs.lib.strings.hasSuffix ".lua" (builtins.toString file)) then
        wrapLuaConfig (builtins.readFile file)
      else
        builtins.readFile file;
    readVimConfig = file: ''
      if !exists('g:vscode')
        ${readVimConfigRaw file}
      endif
    '';
    pluginWithCfg = { plugin, file }: {
      inherit plugin;
      config = readVimConfig file;
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

    plugins = with pkgs.vimPlugins; [
      # coc
      coc-json
      coc-sumneko-lua
      coc-rust-analyzer
      coc-vimlsp
      coc-toml
    ];

    coc = {
      enable = true;
      settings = pkgs.lib.importJSON ./coc-settings.json;
    };

    extraConfig = ''
      ${lib.vimUtils.readVimConfig ./setting.lua}
      ${lib.vimUtils.readVimConfig ./keymap.lua}
      ${lib.vimUtils.readVimConfig ./coc-nvim.vim}
    '';
  };
}
