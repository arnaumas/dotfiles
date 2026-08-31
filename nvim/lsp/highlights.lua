---@diagnostic disable: undefined-global

for _, g in ipairs({
	'@lsp.type.function', '@lsp.type.method', '@lsp.type.parameter',
	'@lsp.type.variable', '@lsp.type.property', '@lsp.type.namespace',
	'@lsp.type.keyword',
}) do hl(g, {}) end

for _, g in ipairs({ '@lsp.typemod.function.declaration', '@lsp.typemod.method.declaration' }) do
	link(g, 'Function')
end
for _, g in ipairs({ '@lsp.type.enumMember', '@lsp.typemod.variable.readonly' }) do link(g, 'Constant') end
link('@lsp.type.string', 'String')
link('@lsp.type.number', 'Number')
link('@lsp.type.comment', 'Comment')

hl('DiagnosticError', { fg = red })
hl('DiagnosticWarn',  { fg = yellow })
hl('DiagnosticInfo',  { fg = blue })
hl('DiagnosticHint',  { fg = cyan })
hl('DiagnosticOk',    { fg = green })

for _, sev in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
	hl('DiagnosticUnderline' .. sev, { undercurl = true })
	for _, kind in ipairs({ 'Sign', 'VirtualText', 'Floating' }) do
		link('Diagnostic' .. kind .. sev, 'Diagnostic' .. sev)
	end
end

link('LspInlayHint', 'UiMuted')
link('LspCodeLens', 'UiMuted')
for _, g in ipairs({ 'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite' }) do
	hl(g, { bg = bg })
end
hl('LspSignatureActiveParameter', { fg = yellow, bold = true })
