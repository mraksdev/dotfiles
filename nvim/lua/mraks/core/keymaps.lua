--[[
  Файл: lua/mraks/core/keymaps.lua
  Описание: Пользовательские горячие клавиши.
  Документация: :h vim.keymap.set
--]]

local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.desc = opts.desc or ""
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Выход из режима вставки
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Отключение подсветки поиска
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Работа с буфером обмена (используем системный регистр "+")
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Работа с буферами и окнами
map("n", "<leader>w", ":w<CR>", { desc = "[W]rite file" })
map("n", "<leader>q", ":bd<CR>", { desc = "[Q]uit buffer" })
map("n", "<leader>Q", ":wqa<CR>", { desc = "[Q]uit Neovim (save all)" })

-- Управление отступами (соответствует движению H/влево, L/вправо)
-- map("n", "<C-H>", preserve_cursor("V<"), { desc = "Decrease indent" })
-- map("n", "<C-L>", preserve_cursor("V>"), { desc = "Increase indent" })
map("v", "<C-H>", "<gv", { desc = "Decrease indent and reselect" })
map("v", "<C-L>", ">gv", { desc = "Increase indent and reselect" })

-- Диагностика LSP
map("n", "<leader>od", vim.diagnostic.setloclist, { desc = "[O]pen [d]iagnostic list" })
