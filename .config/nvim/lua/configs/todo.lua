if not require('utils').isModuleAvailable('todo-comments') then
    --- Only import if available; allows clean bootstrapping.
    return
end
require("todo-comments").setup{
    keywords = {
        ToDo = {
            icon = " ", -- icon used for the sign, and in search results
            color = "info", -- can be a hex color, or a named color (see below)
            alt = {  "CSM" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
        },
        -- -- TODO = { icon = " ", color = "info" },
        -- HACK = { icon = " ", color = "warning" },
        -- WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        -- PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        -- NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        -- TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    merge_keywords=false,
}
