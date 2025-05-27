return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter", -- Neotest might require this for some adapters
      "nvim-neotest/neotest-plenary",
    },
    opts = {
      -- We'll configure adapters later, but it's good to have the section ready
      adapters = {
        ["neotest-plenary"] = {},
      },
      -- Example: Configure neotest to output to a floating window
      output = {
        open_on_run = true,
        floating = {
          max_height = 0.6,
          max_width = 0.6,
        },
      },
      -- Other neotest options can be added here
    },
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },
  {
    "nvim-neotest/neotest-plenary",
    -- No specific opts needed for neotest-plenary itself for now,
    -- it's mostly an adapter that neotest will use.
  },
  -- Ensure plenary is loaded if not already managed elsewhere
  {
    "nvim-lua/plenary.nvim",
    lazy = true, -- Can be lazy-loaded as it's a library
  },
  -- Ensure nvim-nio is loaded (dependency for neotest)
  {
    "nvim-neotest/nvim-nio",
    lazy = true,
  },
  -- Ensure FixCursorHold is loaded
  {
    "antoinemadec/FixCursorHold.nvim",
    lazy = true,
  },
  -- Ensure nvim-treesitter is loaded, as neotest or its adapters might need it.
  -- If you already have nvim-treesitter configured elsewhere, this might be redundant
  -- or could be merged with your existing treesitter config.
  -- For now, adding it here to ensure neotest has what it needs.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "lua" }, -- Ensure lua parser is installed for plenary tests
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    lazy = true,
  },
}
