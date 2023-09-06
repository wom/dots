return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    ---@class CatppuccinOptions
    opts = {
        flavour = "mocha",
        transparent_background = true,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
        },
        integrations = {
            bufferline = true,
            cmp = true,
            -- fidget = true, --  Investigate?
            -- gitsigns = true, Investigate?
            -- harpoon = true,
            lsp_trouble = true,
            notify = true,
            mason = true,
            -- neotest = true,
            -- noice = true,
            -- octo = true,
            telescope = {
                enabled = true,
            },
            treesitter = true,
            treesitter_context = false,
            symbols_outline = true, -- What?
            -- illuminate = true, -- What?
            which_key = true,
            --    barbecue = {
            --      dim_dirname = true,
            --      bold_basename = true,
            --      dim_context = false,
            --      alt_background = false,
            --    },
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
            },
        },
    },
}
