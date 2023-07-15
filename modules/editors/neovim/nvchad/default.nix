{ inputs, config, options, pkgs, lib, ... }:

with lib;
with lib.my;
mkIf (config.modules.editors.neovim.config == "nvchad") {
  files.home = {
    "${config.files.configHome}/nvim" = {
      source = inputs.nvchad;
      recursive = true;
    };

    "${config.files.configHome}/nvim/lua/custom" = {
      source = ./_config;
      recursive = true;
    };
  };
}
