vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", fg = "#a3b1bf" })
	end,
})

return {
	{
		"lunacookies/vim-colors-xcode",
		config = function()
			vim.cmd.colorscheme("xcode")
		end
	}
}
