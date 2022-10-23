require('gitsigns').setup({
    numhl = true,

    on_attach = function (bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<space>tgb', gs.toggle_current_line_blame)
        map('n', '<space>tgd', gs.toggle_deleted)

        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true })
        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

        map({'n', 'v'}, '<space>gs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<space>gr', ':Gitsigns reset_hunk<CR>')
        map('n', '<space>gS', gs.stage_buffer)
        map('n', '<space>gu', gs.undo_stage_hunk)
        map('n', '<space>gR', gs.reset_buffer)
        map('n', '<space>gp', gs.preview_hunk)
        map('n', '<space>gb', function() gs.blame_line{ full = true } end)
        map('n', '<space>gd', gs.diffthis)
        map('n', '<space>gD', function() gs.diffthis('~') end)
    end
})
