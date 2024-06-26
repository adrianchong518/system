local cmp = require "cmp"

local opts = {
  preselect = cmp.PreselectMode.None,
  completion = { completeopt = "menu,menuone,noselect" },
  mapping = {
    ["<CR>"] = cmp.mapping {
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm { select = true },
      c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
    },
    ["<Tab>"] = function(fallback)
      fallback()
    end,
    ["<S-Tab>"] = function(fallback)
      fallback()
    end,
  },
}

return opts
