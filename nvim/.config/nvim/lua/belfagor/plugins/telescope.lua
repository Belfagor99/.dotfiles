return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({

            defaults = {
                -- This ensures icons show up in the file list
                file_ignore_patterns = { "node_modules" },
                path_display = { "truncate" },
                -- Standard icon support
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
            },
            pickers = {
                find_files = {
                    disable_devicons = false, -- Make sure this is false
                },
            }}
        )

        local preview_utils = require("telescope.previewers.utils")
        preview_utils.ts_highlighter = function(bufnr, ft)

            -- GUARD: If filetype is nil or empty, don't even try to highlight
            if not ft or ft == "" then
                return false
            end

            local lang = vim.treesitter.language.get_lang(ft) or ft
            if not lang or lang == "" then
                return false
            end

            return pcall(vim.treesitter.start, bufnr, lang)
        end

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}
