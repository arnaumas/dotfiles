vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '\u{F00D}',
			[vim.diagnostic.severity.WARN] = '\u{F071}',
			[vim.diagnostic.severity.INFO] = '\u{F129}',
			[vim.diagnostic.severity.HINT] = '\u{F128}',
		},
	},
})
