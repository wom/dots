config = function() end
-- Overseer!
return {
    {
        "stevearc/overseer.nvim",
        config = function()
            local overseer = require("overseer")
            overseer.setup()
            overseer.register_template({
                name = "Runner",
                builder = function(params)
                    return {
                        cmd = {
                            vim.api.nvim_buf_get_name(0),
                        },
                        components = {
                            "on_output_quickfix",
                            "default",
                            -- "on_complete_notify",
                        },
                    }
                end,
                tags = { overseer.TAG.BUILD },
                params = {},
                priority = 4,
                condition = {
                    filetype = { "py", "sh", "lua", "go" },
                },
            })
        end,
    },
}
