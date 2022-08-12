if not require('utils').isModuleAvailable('notify') then
    --- Only import if available; allows clean bootstrapping.
    return
end
vim.notify = require('notify')
