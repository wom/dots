return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        animate = { enabled = false },
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,
            formats = {
                key = function(item)
                    return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
                end,
            },
            sections = {
                { title = [[
⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢀⢤⣴⣖⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠈⣿⣿⣾⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⢸⣾⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⣐⣶⣶⠦⠤⠤⠄⣠⣀⡀
⠀⣿⣯⢻⢿⣇⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⣧⣿⣿⠀⠀⠀⢀⠀⠀⠀⠀⠀⡤⣧⣄⠀⠛⢿⣒⣦⣤⣶⡿⠟⠋⠀⠀⠀⠀⠀⠀⠁⠀
⠀⣿⣿⣷⣻⢇⣿⡿⠀⣠⢤⣤⣄⠀⠀⠀⣿⣼⡿⡄⠀⠀⢿⠧⣤⣠⣄⣠⣾⣿⣾⣿⣟⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢿⣿⣿⣿⣷⣿⡾⣺⣵⣿⣦⣊⡟⢶⡾⣿⣟⣾⠂⠀⠀⢸⠃⠀⠀⠀⠀⢀⣤⣾⣿⣿⣟⢛⣻⣭⣿⢛⠛⠾⢶⣄⠀⠀⠀⠀⠀⠀
⠀⢸⣿⣫⣿⣿⣿⣿⡟⢿⣿⣿⣫⠗⠋⢱⣟⣽⣿⠀⠀⠀⠀⠀⠀⣀⡴⣾⡿⠿⠿⣿⡿⠈⠙⠿⣿⣗⣵⣶⣤⣀⠀⠉⠒⠤⣤⡄⠀
⠀⠸⣿⣿⣿⢻⣿⣯⡇⠈⠈⠉⠀⠀⠀⢸⣾⡏⣿⡀⠀⠀⠀⢠⣾⠽⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⡻⣷⣄⠀⠀⠈⠈⠀
⠀⠀⢹⣿⣿⣇⣿⣾⡇⠀⠀⠀⠀⠀⠀⠈⣿⣧⣿⡇⠀⠀⠀⠀⢻⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠛⠀⠀⠀⠀⠀
⠀⠀⠀⢻⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⡿⠁⠀⠀⠀⠀⠈⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠈⢯⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠃⠀⠀⠀⠀⠀⠀⢹⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                ]], padding = 1, align =  'center' },
                { section = "recent_files", cwd = true, limit = 3, padding = 1 },
                { section = "keys" },
            },
        },
        explorer = { enabled = false },
        indent = { enabled = false },
        input = { enabled = true },
        lazygit = { enabled = true },
        picker = { enabled = false },
        notifier = { enabled = false },
        quickfile = { enabled = false },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = false },
    },
}
