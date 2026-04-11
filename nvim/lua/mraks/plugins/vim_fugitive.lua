return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gf", vim.cmd.Git, { desc = "Open Git [F]ugitive" })
	end,
}
