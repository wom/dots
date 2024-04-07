return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
        require("ibl").setup({
            indent = { char = "│" },
            scope = { enabled = false },
            whitespace = { remove_blankline_trail = false },
            exclude = {
                buftypes = { "terminal", "nofile", "quickfix", "prompt" },
                filetypes = { "help", "startify", "dashboard", "packer", "Yanil", "alpha" },
            },
        })
    end,
}

