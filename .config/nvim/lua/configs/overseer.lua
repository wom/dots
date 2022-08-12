if not require('utils').isModuleAvailable('overseer') then
    --- Only import if available; allows clean bootstrapping.
    return
end
local overseer = require("overseer")
overseer.setup()
overseer.register_template({
  name = "Runner",
  builder = function(params)
    return {
      cmd = {
        vim.api.nvim_buf_get_name(0),
      },
    }
  end,
  tags = { overseer.TAG.BUILD },
  params = {},
  priority = 4,
  condition = {
    filetype = { "py", "sh", "lua" },
  },
})
