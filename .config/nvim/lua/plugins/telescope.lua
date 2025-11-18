return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                file_ignore_patterns = { "node_modules", ".git/" },
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                path_display = { "truncate" },
                winblend = 0,
                border = true,
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                use_less = true,
                set_env = { ["COLORTERM"] = "truecolor" },

                mappings = {
                    i = {
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-c>"] = actions.close,
                        ["<Down>"] = actions.move_selection_next,
                        ["<Up>"] = actions.move_selection_previous,
                        ["<CR>"] = actions.select_default,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = actions.select_tab,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                    },
                    n = {
                        ["<esc>"] = actions.close,
                        ["q"] = actions.close,
                        ["<CR>"] = actions.select_default,
                        ["<C-x>"] = actions.select_horizontal,
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-t>"] = actions.select_tab,
                        ["j"] = actions.move_selection_next,
                        ["k"] = actions.move_selection_previous,
                        ["H"] = actions.move_to_top,
                        ["M"] = actions.move_to_middle,
                        ["L"] = actions.move_to_bottom,
                        ["gg"] = actions.move_to_top,
                        ["G"] = actions.move_to_bottom,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                    },
                },
            },

            pickers = {
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                    hidden = true,
                },
                live_grep = {
                    theme = "dropdown",
                    only_sort_text = true,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    initial_mode = "normal",
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.delete_buffer,
                        },
                        n = {
                            ["dd"] = actions.delete_buffer,
                        },
                    },
                },
                planets = {
                    show_pluto = true,
                    show_moon = true,
                },
                git_files = {
                    theme = "dropdown",
                    previewer = false,
                },
                help_tags = {
                    theme = "ivy",
                },
            },

            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })

        require("telescope").load_extension("fzf")
    end,
}
