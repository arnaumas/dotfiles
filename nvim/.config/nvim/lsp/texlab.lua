-- texlab config, auto-discovered by vim.lsp.enable('texlab').
return {
	cmd          = { 'texlab' },
	filetypes    = { 'tex', 'plaintex', 'bib' },
	root_markers = { '.latexmkrc', '.git' },
	settings = {
		texlab = {
			-- Suppress noisy ChkTeX warnings by message regex.
			diagnostics = {
				ignoredPatterns = { 'Command terminated with space' },
			},
			-- LaTeX linting via chktex -> inline diagnostics (TeXstudio-like).
			chktex = {
				onOpenAndSave = true,   -- lint on open + save (quiet, recommended)
				onEdit        = false,  -- set true for live linting (noisier)
			},
			-- Formatting via latexindent (enables gq / format on .tex).
			latexFormatter = 'latexindent',
			-- NOTE: build / forwardSearch deliberately unset -- VimTeX owns
			-- compilation and sioyek SyncTeX.
		},
	},
}
