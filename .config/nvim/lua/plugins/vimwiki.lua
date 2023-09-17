return {
    {
        "vimwiki/vimwiki",
        event = "VeryLazy",
        config = function()
            vim.g.vimwiki_list = {
                {
                    path = "~/vimwiki",
                    syntax = "markdown",
                    ext = ".wiki",
                },
            }
            vim.g.vimwiki_ext2syntax = {
                [".md"] = "markdown",
                [".wiki"] = "markdown",
                [".markdown"] = "markdown",
                [".mdown"] = "markdown",
            }
        end,
    },
}
