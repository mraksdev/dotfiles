return {
	"jiaoshijie/undotree",
	opts = {
		-- your options
	},
	config = function()
		vim.keymap.set("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "[U]ndotree Toggle" })
	end,
}
