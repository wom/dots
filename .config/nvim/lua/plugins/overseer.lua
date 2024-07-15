return {
    {
        "stevearc/overseer.nvim",
        config = function()
            local os = require("overseer")
            os.setup()
            os.register_template(
                {
                    name = "Runner",
                    builder = function(params)
                        return {
                            cmd = {
                                vim.api.nvim_buf_get_name(0),
                            },
                            components = {
                                "on_output_quickfix",
                                "default",
                                "on_complete_notify",
                            },
                        }
                    end,
                    tags = { os.TAG.BUILD },
                    params = {},
                    priority = 4,
                    condition = {
                        filetype = { "python", "sh", "lua", "go" },
                    },
                }
            )
        end
    }
}
