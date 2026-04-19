--[[
  Файл: lua/mraks/plugins/colorschemes.lua
  Описание: Установка и активация цветовых схем.
--]]

return {
	-- Gruvbox (активная тема по умолчанию)
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		lazy = true,
		opts = {
			terminal_colors = true,
			transparent_mode = false,
		},
		config = function(_, opts)
			require("gruvbox").setup(opts)
			-- vim.cmd.colorscheme("gruvbox")
		end,
	},

	-- Catppuccin (альтернативная тема)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		opts = {
			flavour = "frappe",
			transparent_background = true,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin-frappe")
		end,
	},
}
