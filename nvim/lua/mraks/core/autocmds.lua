--[[
  Файл: lua/mraks/core/autocmds.lua
  Описание: Автокоманды (автоматические действия при событиях).
  Документация: :h nvim_create_autocmd
--]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local user_group = augroup("MraksConfig", { clear = true })

-- Подсветка скопированного текста (yank)
autocmd("TextYankPost", {
	group = user_group,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- Настройка `colorcolumn` для разных типов файлов
autocmd("FileType", {
	group = user_group,
	pattern = "*",
	callback = function(args)
		vim.opt_local.colorcolumn = ""
		local ft = args.match
		if ft == "python" then
			vim.opt_local.colorcolumn = "81"
		elseif ft == "lua" then
			vim.opt_local.colorcolumn = "120"
		elseif ft == "html" or ft == "htmldjango" then
			vim.opt_local.colorcolumn = "300"
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		-- Если файл не оканчивается на ".diff", выполняем команду
		if not vim.endswith(args.file, ".diff") then
			vim.cmd([[%s/\s\+$//e]])
		end
	end,
})
