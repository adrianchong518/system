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
    ./ayu

    # Editor Features
    ./autopairs
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
