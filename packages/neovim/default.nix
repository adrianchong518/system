{ pkgs, inputs, lib, stdenv, ... }:
let
  mkNeovimConfig = pkgs.callPackage ../mkNeovimConfig.nix { };
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  stable = import inputs.nixpkgs-stable { inherit (pkgs) system; };
in
mkNeovimConfig {
  appName = "nvim";
  configSrc = ./config;

  withNodeJs = true;

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server
    nil # nix LSP
    nixpkgs-fmt
    dockerfile-language-server
  ];

  plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    stable.vimPlugins.nvim-treesitter.withAllGrammars
    luasnip # snippets | https://github.com/l3mon4d3/luasnip/

    # nvim-cmp (autocompletion) and extensions
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions
    # ^ nvim-cmp extensions

    # git integration plugins
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    vim-fugitive # https://github.com/tpope/vim-fugitive/
    # ^ git integration plugins

    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim/
    telescope-file-browser-nvim # https://github.com/nvim-telescope/telescope-file-browser.nvim/
    # ^ telescope and extensions

    oil-nvim # file explorer | https://github.com/stevearc/oil.nvim/

    copilot-lua
    copilot-cmp
    copilot-lualine
    codecompanion-nvim

    # UI
    catppuccin-nvim # Catppuccin theme | https://github.com/catppuccin/nvim/
    which-key-nvim # Which key | https://github.com/folke/which-key.nvim
    trouble-nvim # pretty lists | https://github.com/folke/trouble.nvim/
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    stable.vimPlugins.nvim-treesitter-context # nvim-treesitter-context
    # fidget-nvim # lsp loading progess | https://github.com/j-hui/fidget.nvim/
    # noice-nvim
    # ^ UI

    # language support
    nvim-lspconfig # more convenient lsp config | nvim-lspconfig
    none-ls-nvim
    neodev-nvim # adds support for Neovim's Lua API to lua-language-server | https://github.com/folke/neodev.nvim/
    rustaceanvim # rust-tools successor | https://github.com/mrcjkb/rustaceanvim/
    crates-nvim # check crate versions in Cargo.toml | https://github.com/saecki/crates.nvim/
    neogen # generate documentation template | https://github.com/danymat/neogen/
    vimtex
    tailwind-tools-nvim
    nvim-ts-autotag
    plantuml-syntax
    markdown-preview-nvim
    # ^ language support

    # navigation/editing enhancement plugins
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    nvim-surround # https://github.com/kylechui/nvim-surround/
    stable.vimPlugins.nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    auto-hlsearch-nvim # https://github.com/asiryk/auto-hlsearch.nvim/
    nvim-ufo # https://github.com/kevinhwang91/nvim-ufo/
    todo-comments-nvim # https://github.com/folke/todo-comments.nvim/
    comment-nvim # https://github.com/numtostr/comment.nvim/
    smart-splits-nvim # pane navigation integration with tmux/wezterm | https://github.com/numToStr/Navigator.nvim/
    nvim-autopairs # autopairs | https://github.com/windwp/nvim-autopairs/
    indent-blankline-nvim # Add indentation guides | https://github.com/lukas-reineke/indent-blankline.nvim/
    # inc-rename-nvim
    leap-nvim
    flit-nvim
    # ^ navigation/editing enhancement plugins

    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    # ^ Useful utilities

    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    vim-repeat
    promise-async
    nui-nvim
    mini-nvim
    # ^ libraries that other plugins depend on

    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    # (mkNvimPlugin inputs.remote-nvim "remote-nvim")
    # ^ bleeding-edge plugins from flake inputs
  ];
}
