local lsp = require('lspconfig')
local configs = require('lspconfig.configs')

if not configs.rnix then
    configs.rnix = {
        default_config = {
            cmd = { 'rnix-lsp' };
            filtypes = { 'nix' };
            root_dir = function(fname)
                return lsp.util.find_git_ancestor(fname) or vim.loop.cwd()
            end;
            settings = {};
        }
    }
end

lsp.rnix.setup({})
