{ pkgs, ... }:

{
  imports = [
    ./theme
    ./lualine

    ./coc
    ./treesitter
    ./plenary

    # ./fzf
    ./tagbar
    ./telescope
    ./tree

    ./surround
    ./autopairs
    ./comment
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-lion
    nvim-web-devicons

    vim-nix
  ];
}
