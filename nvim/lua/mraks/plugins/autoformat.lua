return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>F",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = {
				c = true,
				cpp = true,
			}
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "autoflake", "autopep8" },
			html = { "prettier" },
			--- For this formater need to crate
			--- pyproject.toml in root dir of the project
			--- set indent to 2 like base html
			--- with content
			--- [tool.djlint]
			--- indent=2
			--- max_attribute_length=500
			---
			--- link to config docs
			--- https://djlint.com/docs/configuration/
			htmldjango = { "djlint" },
		},
	},
}
