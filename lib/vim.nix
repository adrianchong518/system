{ lib, ... }:

rec {
  wrapLuaConfig = luaConfig: ''
    lua<<EOF
    ${luaConfig}
    EOF
  '';

  readVimConfigRaw = file:
    if (lib.strings.hasSuffix ".lua" (builtins.toString file)) then
      wrapLuaConfig (builtins.readFile file)
    else
      builtins.readFile file;

  readVimConfig = file: ''
    if !exists('g:vscode')
    ${readVimConfigRaw file}
    endif
  '';

  readVimLuaConfigs = files: ''
    if !exists('g:vscode')
    lua << EOF
    ${lib.concatMapStringsSep "\n" builtins.readFile files}
    EOF
    endif
  '';

  pluginWithCfg = { plugin, file ? null, files ? [ ] }: {
    inherit plugin;
    config = ''
      ${if (file != null) then readVimConfig file else ""}
      ${lib.concatMapStringsSep "\n" readVimConfig files}
    '';
  };
}

