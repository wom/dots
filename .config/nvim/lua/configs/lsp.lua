if not require('utils').isModuleAvailable('null-ls') then
    --- Only import if available; allows clean bootstrapping.
    return
end
if not require('utils').isModuleAvailable('lspsaga') then
    --- Only import if available; allows clean bootstrapping.
    return
end
null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.pylint.with({
      diagnostics_postprocess = function(diagnostic)
        diagnostic.code = diagnostic.message_id
      end,
    }),
    null_ls.builtins.formatting.isort,
    null_ls.builtins.diagnostics.shellcheck,
    -- null_ls.builtins.formatting.black, -- One Day.
  },
})

local saga = require("lspsaga")

saga.init_lsp_saga({
})
