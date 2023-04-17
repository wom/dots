if not require('utils').isModuleAvailable('null-ls') then
    --- Only import if available; allows clean bootstrapping.
    return
end
if not require('utils').isModuleAvailable('lspsaga') then
    --- Only import if available; allows clean bootstrapping.
    return
end
if not require('utils').isModuleAvailable('cmp') then
    --- Only import if available; allows clean bootstrapping.
    return
end
-- Null
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    -- pylint out, Ruff in
    -- null_ls.builtins.diagnostics.pylint.with({
    --   diagnostics_postprocess = function(diagnostic)
    --     diagnostic.code = diagnostic.message_id
    --   end,
    -- }),
    null_ls.builtins.formatting.ruff,
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.yamllint,
    -- null_ls.builtins.formatting.autopep8,
    null_ls.builtins.formatting.black, -- One Day.

  },
})

--- lspsaga!
require("lspsaga").setup()

-- nvim-cmp
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'treesitter' },
        { name = 'pyright' },
        { name = 'path' },
        { name = 'luasnip' }, -- For vsnip users.
    }, {
            { name = 'buffer' },
        })
})
