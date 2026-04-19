return {
	"mistweaverco/snap.nvim",
	version = "v1.5.0",
	cmd = "Snap",
	opts = {
		timeout = 5000, -- Timeout for screenshot command in milliseconds
		log_level = "error", -- Log level for debugging (e.g., "trace", "debug", "info", "warn", "error", "off")
		template = "default", -- Template to use for rendering screenshots ("default", "macos", "linux")
		template_filepath = nil, -- Absolute path to a custom handlebars template file (optional), overrides 'template' option
		-- Additional data to pass to the your custom handlebars template (optional)
		additional_template_data = {
			author = "Alex Krylov",
			website = "https://mraksdev.github.com",
		},
		output_dir = "$HOME/Pictures/Screenshots", -- Directory to save screenshots
		filename_pattern = "codesnap_%t", -- e.g., "snap.nvim_%t" (supports %t for timestamp)
		save_to_disk = {
			image = true, -- Whether to save the image to disk
			html = true, -- Whether to save the HTML to disk
		},
		copy_to_clipboard = {
			image = false, -- Whether to copy the image to clipboard
			html = false, -- Whether to copy the HTML to clipboard
		},
		font_settings = {
			size = 14, -- Default font size for the screenshot in pt
			line_height = 1.0, -- Default line height for the screenshot in pt
			default = {
				name = "Hack Nerd Font", -- Default font name for the screenshot
				file = nil, -- Absolute path to a custom font file (.ttf) (optional)
				-- Only needed if the font is not installed system-wide
				-- or if you want to export as HTML with the font embedded
				-- so you can view it correctly in E-mails or browsers
			},
			-- Optional font settings for different text styles (bold, italic, bold_italic)
			bold = {
				name = "Hack Nerd Font", -- Font name for bold text
				file = nil, -- Absolute path to a custom font file (.ttf) (optional)
				-- Only needed if the font is not installed system-wide
				-- or if you want to export as HTML with the font embedded
				-- so you can view it correctly in E-mails or browsers
			},
			italic = {
				name = "Hack Nerd Font", -- Font name for italic text
				file = nil, -- Absolute path to a custom font file (.ttf) (optional)
				-- Only needed if the font is not installed system-wide
				-- or if you want to export as HTML with the font embedded
				-- so you can view it correctly in E-mails or browsers
			},
			bold_italic = {
				name = "Hack Nerd Font", -- Font name for bold and italic text
				file = nil, -- Absolute path to a custom font file (.ttf) (optional)
				-- Only needed if the font is not installed system-wide
				-- or if you want to export as HTML with the font embedded
				-- so you can view it correctly in E-mails or browsers
			},
		},
	},
	event = "VeryLazy",
}
