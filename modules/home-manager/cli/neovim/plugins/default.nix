{ config, pkgs, lib, ... }:

{
  imports = [
    ./plenary

    # UI / Theming
    ./lazygit
    ./lualine
    ./tagbar
    ./telescope

    # ./theme
    ./tree
    # ./ayu
    # ./srcery
    ./gruvbox-material

    # Editor Features
    ./autopairs
    ./centerpad
    ./comment
    ./gitsigns
    ./illuminate
    ./indent_blankline
    ./surround
    ./todo-comments

    # Language / LSP
    ./treesitter
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-web-devicons

    # Editor Features
    vim-lion

    # Language / LSP
    vim-nix
  ];
}
