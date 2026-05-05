vim.g.mapleader = " "
vim.keymap.set("n","<leader>pv",vim.cmd.Ex)

-- Visual mode remap
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")



-- Normal mode remap
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")


-- paste over a visual selection without losing the item you just pasted.
vim.keymap.set("x", "<leader>p", [["_dP]])

--Deletes text permanently without cutting it.
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- Yanks text directly to system clipboard. Y get entire line automatically
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


-- ERRORS
-- Trigger a popup that ONLY shows Warnings
vim.keymap.set("n", "<leader>w", function()
    vim.diagnostic.open_float({ severity = vim.diagnostic.severity.WARN })
end)

-- You might still want this for Errors/Everything else
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- Open terminal in a new vertical split on the right. PWS or WSL
local term_size = 100

vim.keymap.set("n", "<leader>t", function()
    vim.cmd(term_size .. "vnew")
    vim.cmd.term("pwsh -NoLogo")
    vim.cmd.startinsert()
end)

vim.keymap.set("n", "<leader>T", function()
    vim.cmd(term_size .. "vnew")
    vim.cmd.term("wsl")
    vim.cmd.startinsert()
end)
-- Easy escape from terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
-- Use Alt + Arrow keys to resize windows
vim.keymap.set("n", "<M-Up>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<M-Down>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<M-Left>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<M-Right>", "<cmd>vertical resize +2<cr>")
