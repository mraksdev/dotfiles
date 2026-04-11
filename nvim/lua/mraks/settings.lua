vim.o.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.smartindent = true

vim.o.wrap = false
vim.o.breakindent = true

local undodir = vim.fn.stdpath("config") .. "/.undo"
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "81"
vim.opt.isfname:append("@-@")

vim.opt.fillchars = { eob = " " }

vim.opt.updatetime = 50
vim.o.timeoutlen = 300

vim.o.inccommand = "split"

vim.o.confirm = true

vim.opt.modified = true

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

local function on_jump(diagnostic, bufnr)
	if not diagnostic then
		return
	end

	vim.diagnostic.show(
		diagnostic.namespace,
		bufnr,
		{ diagnostic },
		{ virtual_lines = { current_line = true }, virtual_text = false }
	)
end

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Text shows up underneath the line, with virtual lines

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = { on_jump = on_jump },
})
