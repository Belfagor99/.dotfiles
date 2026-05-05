return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        -- Basic Mappings
        -- <leader>a to mark a file (add to list)
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Mark File" })

        -- <C-e> to toggle the visual menu (edit your list)
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Menu" })

        -- Navigation: Mapping to specific slots 1-4
        -- Using <leader> + number is often safer than Ctrl+h/j/k/l in complex configs
        vim.keymap.set("n", "<M-1>", function() harpoon:list():select(1) end, { desc = "Harpoon: File 1" })
        vim.keymap.set("n", "<M-2>", function() harpoon:list():select(2) end, { desc = "Harpoon: File 2" })
        vim.keymap.set("n", "<M-3>", function() harpoon:list():select(3) end, { desc = "Harpoon: File 3" })
        vim.keymap.set("n", "<M-4>", function() harpoon:list():select(4) end, { desc = "Harpoon: File 4" })
        vim.keymap.set("n", "<M-5>", function() harpoon:list():select(5) end, { desc = "Harpoon: File 5" })

        -- Toggle previous & next buffers in the harpoon list
        vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon: Prev" })
        vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon: Next" })
    end,
}
