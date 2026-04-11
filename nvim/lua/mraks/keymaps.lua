-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Exit insert mode
vim.keymap.set("i", "jk", "<Esc>")

-- File explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "File [E]xplorer" })

-- Buffer manipulations
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "[W]rite file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "[Q]uit Buffer" })
vim.keymap.set("n", "<leader>Q", ":wqa<CR>", { desc = "[Q]uit Nvim" })

-- remove higlights after search on ESC
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Copy nad Paste from sytem clipboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Navigate slpits
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Diagnostics
vim.keymap.set("n", "<leader>od", vim.diagnostic.setloclist, { desc = "[O]pen [d]iagnostic quickfix list" })
