return { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
        -- `gc` default mapping
        require("mini.comment").setup()

        -- session management. <leader>ms
        require("mini.sessions").setup()

        -- File management!
        require("mini.files").setup()

        -- Misc - mostly for zoom()
        require("mini.misc").setup()
        --
        require("mini.animate").setup()

        -- notifications! Doesn't have a great show_notifications interface, so skipping for now.
        -- local win_config = function()
        --     -- Place notifications in bottom-right
        --     local has_statusline = vim.o.laststatus > 0
        --     local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
        --     return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
        -- end
        -- require("mini.notify").setup({
        --     window = {
        --         config = win_config 
        --     }
        -- })

        -- Simple statusline.
        local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        statusline.setup { use_icons = vim.g.have_nerd_font }

        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return '%2l:%-2v'
        end
    end,
}
