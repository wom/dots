if not require('utils').isModuleAvailable('neorg') then
    --- Only import if available; allows clean bootstrapping.
    return
end
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/org/work",
                    home = "~/org/home",
                }
            }
        }
    }
}
