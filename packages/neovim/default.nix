{ pkgs, inputs, ... }:
let
  mkNeovimConfig = pkgs.callPackage ../mkNeovimConfig.nix { };
in
mkNeovimConfig {
  appName = "nvim-new";
  package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
  configSrc = ./config;

  withNodeJs = true;

  extraPackages = with pkgs; [
    lua-language-server
    nil # nix LSP
    nixpkgs-fmt
    dockerfile-language-server
    copilot-language-server

    texlab

    tinymist
    websocat

    ripgrep
  ];

  plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    nvim-lspconfig
    none-ls-nvim

    blink-cmp
    blink-copilot
    lazydev-nvim

    vimtex
    markdown-preview-nvim
    typst-preview-nvim

    oil-nvim
    leap-nvim

    neogit
    gitsigns-nvim

    catppuccin-nvim

    nvim-window-picker
    mini-nvim
    plenary-nvim
    nvim-web-devicons
  ];
}
