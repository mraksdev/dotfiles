return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- optional but recommended
		{ "nvim-telescope/telescope-fzf-native.nvim" },
	},
	opts = {
		defaults = {
			preview = {
				treesitter = true,
			},
		},
	},
	config = function()
		require("telescope").setup({})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find [f]iles" })
		vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Find [g]it files" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find [h]elp tags" })
		vim.keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find, { desc = "Find in [b]uffer" })
		vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find [s]tring" })
	end,
}
