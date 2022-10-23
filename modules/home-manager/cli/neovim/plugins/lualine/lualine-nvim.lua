require('lualine').setup({
    options = { theme = 'onedark' },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
            },
        },
    },
    inactive_sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
            },
        },
    },
})
