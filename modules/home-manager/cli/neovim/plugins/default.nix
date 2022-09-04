{ pkgs, ... }:

{
  imports = [
    ./theme
    ./lualine

    ./coc
    ./treesitter

    ./fzf

    ./surround
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-lion
  ];
}
