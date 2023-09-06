if not require('utils').isModuleAvailable('catppuccin') then
    --- Only import if available; allows clean bootstrapping.
    print('Cat-pee not installed yet.')
    return
end
-- darkmode
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
vim.cmd([[colorscheme catppuccin]])
-- lightmode
-- vim.g.catppuccin_flavour = "latte" -- latte, frappe, macchiato, mocha
require("catppuccin").setup({
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    transparent_background = false,
    term_colors = false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    integrations = {
        -- gitsigns = true, -- I might want this?
        bufferline = true,
        cmp = true,
        dashboard = true,
        harpoon = true,
        notify = true,
        nvimtree = true,
        overseer = true,
        -- special = true, -- I think this is for indent blankline
        -- telescope = true,
        treesitter = true,
        -- trouble = true, borked
        vimwiki = true,
        which_key = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
    color_overrides = {},
    custom_highlights = {},
})
