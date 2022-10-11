if not require('utils').isModuleAvailable('trouble') then
    --- Only import if available; allows clean bootstrapping.
    return
end

require("trouble").setup {
    passing = false,
    mode = "document_diagnostics",
    use_diagnostic_signs = true

}


-- If we have telescope, hook into it to pull results up
if not require('utils').isModuleAvailable('telescope') then
    --- Only import if available; allows clean bootstrapping.
    return
else
    local actions = require("telescope.actions")
    local trouble = require("trouble.providers.telescope")

    local telescope = require("telescope")

    telescope.setup {
        defaults = {
            mappings = {
                i = { ["<c-t>"] = trouble.open_with_trouble },
                n = { ["<c-t>"] = trouble.open_with_trouble },
            },
        },
    }
end

