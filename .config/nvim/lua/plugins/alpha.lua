return {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        local alpha = require'alpha'
        local dashboard = require'alpha.themes.dashboard'
        local art = require('utils.ascii')
        -- Set the header
        dashboard.section.header.opts.hl = "Function"
        dashboard.section.header.val = art.saturn

        -- Set the buttons
        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "  Find Text", ":Telescope live_grep<CR>"),
            dashboard.button("c", "  Config", ":lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })<CR>"),
            dashboard.button("u", "  Update", ":Lazy update<CR>"),
            dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        -- Set the footer
        dashboard.section.footer.val = "neovim | alpha"

        -- Send config to alpha
        alpha.setup(dashboard.config)
    end
}
