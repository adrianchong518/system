{ config, pkgs, lib, ... }:

rec {
  home.shellAliases = {
    v = "nvim";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      impatient-nvim

      # UI / Theming
      nvim-web-devicons
      awesome-vim-colorschemes
      lualine-nvim

      # Panels
      nvim-tree-lua
      tagbar
      telescope-nvim
      telescope-coc-nvim
      telescope-fzf-native-nvim

      # Editor Features
      vim-lion
      nvim-surround
      nvim-comment
      nvim-autopairs
      indent-blankline-nvim

      # Language / LSP
      vim-nix

      # Treesitter
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      nvim-treesitter-context

      # coc
      coc-json
      coc-lua
      coc-rust-analyzer
      coc-vimlsp
      coc-toml
    ];

    coc = {
      enable = true;
      settings = lib.importJSON ./coc-settings.json;
    };

    extraPackages = with pkgs; [
      universal-ctags
    ];

    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./nvim.lua}
      EOF

      " coc configs
      ${builtins.readFile ./coc-nvim.vim}

      " Set up ctags for tagbar
      let g:tagbar_ctags_bin = '${pkgs.universal-ctags}/bin/ctags'
    '';
  };

  xdg.configFile."plenary-types.lua" = {
    source = ./plenary-types.lua;
    target = "nvim/data/plenary/filetypes/plenary-types.lua";
  };
}
