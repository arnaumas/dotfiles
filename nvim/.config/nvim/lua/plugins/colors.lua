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
					vim.g.edge_transparent_background = 1
					vim.g.edge_enable_italic = true
					vim.api.nvim_create_autocmd('ColorScheme', {
						group = vim.api.nvim_create_augroup('custom_highlights_edge', {}),
						pattern = 'edge',
						callback = function()
										vim.api.nvim_set_hl(0, 'Visual', { link = 'IncSearch' })
						end
					})
					vim.cmd.colorscheme('edge')
				end
			}
		}
