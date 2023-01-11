require('treesitter-context').setup({
    patterns = {
        rust = {
            'impl_item',
            'struct',
            'enum',
            'mod',
        }
    }
})
