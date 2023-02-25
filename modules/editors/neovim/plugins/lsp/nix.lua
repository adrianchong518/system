configs.rnix = {
    default_config = {
        cmd = { "rnix-lsp" },
        filetypes = { "nix" },
        root_dir = function(fname)
            return require("lspconfig").util.find_git_ancestor(fname) or vim.loop.cwd()
        end,
        settings = {},
    }
}

lsp.rnix.setup({
    on_attach = on_attach,
})
