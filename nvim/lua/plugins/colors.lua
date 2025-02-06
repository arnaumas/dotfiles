-- vim.api.nvim_create_autocmd("ColorScheme", {
	-- pattern = "*",
	-- callback = function()
	-- 	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- 	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	-- 	vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", fg = "#a3b1bf" })
	-- end,
-- })

return {
	{
		"lunacookies/vim-colors-xcode",
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		variant = "dawn",
		disable_background = true
	},

	{
		"zenbones-theme/zenbones.nvim",
		dependencies = "rktjmp/lush.nvim"
	},
	
	{
		"sainnhe/edge",
		config = function()
			vim.cmd.colorscheme('edge')
			vim.g.edge_transparent_background = 1
		end
	}
}
