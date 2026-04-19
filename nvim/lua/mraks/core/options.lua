--[[
  Файл: lua/mraks/options.lua
  Описание: Базовые настройки Neovim.
  Документация: :h vim.opt
--]]

local opt = vim.opt

-- UI / Внешний вид
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "81"
opt.fillchars = { eob = " " }
opt.scrolloff = 10

-- Отступы и табуляция
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.breakindent = true

-- Поведение поиска
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Файлы подкачки, резервные копии и undo
opt.undodir = vim.fn.stdpath("config") .. "/.undo//"
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Управление окнами и производительность
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 50
opt.timeoutlen = 300

-- Разное
opt.inccommand = "split"
opt.confirm = true
opt.isfname:append("@-@")
