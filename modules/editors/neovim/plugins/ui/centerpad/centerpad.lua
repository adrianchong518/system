vim.keymap.set("n", "<space>tc", function () require("centerpad").toggle({leftpad = 60, rightpad = 60 }) end, { silent = true })
vim.keymap.set("n", "<space>tC", function () require("centerpad").toggle({leftpad = 160, rightpad = 160 }) end, { silent = true })
