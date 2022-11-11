if not require('utils').isModuleAvailable('luasnip') then
    --- Only import if available; allows clean bootstrapping.
    return
end

-- autocomplete!
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
ls.config.setup {
    -- This tells LuaSnip to remember to keep around the last snippet.
    -- You can jump back into it even if you move outside of the selection
    history = true,

    -- This one is cool cause if you have dynamic snippets, it updates as you type!
    -- gives me errs.
    updateevents = "TextChanged,TextChangedI",

    -- Autosnippets:
    enable_autosnippets = true,
}

-- shorcut to source my luasnips file again, which will reload my snippets - pathing
-- vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
require("luasnip.loaders.from_vscode").lazy_load() -- Loads FriendlySnippets
-- My Snippets
ls.add_snippets("python", {
    s({trig='"""', dscr="Docstring!"}, { -- generic docstring - how do I do this with 1 trigger?
        t({ '"""', '' }),
        i(1, "describe!"),
        t({ '', '"""' })
    }),
    s({trig="'''", dscr="Docstring!"}, { -- generic docstring
        t({ '"""', '' }),
        i(1, "describe!"),
        t({ '', '"""' })
    })
})
