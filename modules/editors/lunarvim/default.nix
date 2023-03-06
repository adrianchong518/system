{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.lunarvim;

  LUNARVIM_RUNTIME_DIR = "${config.files.dataHome}/lunarvim";
  LUNARVIM_CONFIG_DIR = "${config.files.configHome}/lvim";
  LUNARVIM_CACHE_DIR = "${config.files.cacheHome}/lvim";
  LUNARVIM_BASE_DIR = inputs.lunarvim;

  bin = "${config.files.binHome}/lvim";
in
{
  options.modules.editors.lunarvim = with types; {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    hm.programs.neovim = {
      enable = true;
      withNodeJs = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        fd
        ripgrep
      ];
    };

    files.home = {
      "${LUNARVIM_CONFIG_DIR}" = {
        source = ./_config;
        recursive = true;
      };

      "${bin}" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR}"
          export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR}"
          export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR}"

          export LUNARVIM_BASE_DIR="${LUNARVIM_BASE_DIR}"

          exec -a lvim nvim -u "$LUNARVIM_BASE_DIR/init.lua" "$@"
        '';
      };
    };

    hm.home.activation.syncLVimPacker = hm.dag.entryAfter [ "writeBoundary" ] ''
      # Sync packer plugins in LunarVim
      if ! type "${bin}" > /dev/null; then
        echo >&2 "warning: lvim not installed"
      else
        "${bin}" --headless \
          -c 'autocmd User PackerComplete quitall' \
          -c 'PackerSync'
      fi
    '';
  };
}
