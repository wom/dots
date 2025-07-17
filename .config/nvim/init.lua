--[[
  Neovim Configuration Entry Point
  
  This is the main configuration file for Neovim that loads the core modules.
  It sets up the basic configuration by requiring three essential modules:
  - wom: Core functionality and utilities
  - keymaps: Key binding definitions
  - options: Editor settings and preferences
--]]

-- Load core functionality and utilities
require("core.wom")

-- Load custom key bindings and shortcuts
require("core.keymaps")

-- Load editor options and settings
require("core.options")
