vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '\u{F057}',
			[vim.diagnostic.severity.WARN] = '\u{F071}',
			[vim.diagnostic.severity.INFO] = '\u{F05A}',
			[vim.diagnostic.severity.HINT] = '\u{F05B}',
		},
	},
})
