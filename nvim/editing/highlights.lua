---@diagnostic disable: undefined-global

for _, g in ipairs({
	'@function.call', '@function.builtin', '@function.method.call',
	'@keyword', '@conditional', '@repeat',
	'@variable', '@variable.parameter', '@variable.member',
	'@property', '@field', '@type', '@type.builtin',
	'@module', '@namespace', '@tag.attribute',
}) do hl(g, {}) end

link('@comment', 'Comment')
link('@string', 'String')
link('@character', 'Character')
link('@number', 'Number')
link('@boolean', 'Boolean')
for _, g in ipairs({ '@constant', '@constant.builtin', '@constant.macro' }) do link(g, 'Constant') end
for _, g in ipairs({ '@function', '@function.method', '@constructor' }) do link(g, 'Function') end
link('@tag', 'Tag')
for _, g in ipairs({
	'@operator', '@punctuation.delimiter', '@punctuation.bracket', '@punctuation.special',
	'@tag.delimiter',
}) do link(g, 'Delimiter') end
for _, g in ipairs({ '@label', '@markup.list' }) do link(g, 'UiMuted') end

hl('@comment.error',   { fg = red,    bold = true })
hl('@comment.warning', { fg = yellow, bold = true })
hl('@comment.todo',    { fg = blue,   bold = true })
hl('@comment.note',    { fg = cyan,   bold = true })
hl('@string.escape',   { fg = cyan })
hl('@string.special',  { fg = cyan })
hl('@variable.builtin', { fg = magenta })
hl('@type.definition',  { fg = blue })
hl('@attribute',        { fg = cyan })
hl('@markup.heading', { fg = blue, bold = true })
hl('@markup.strong',  { bold = true })
hl('@markup.italic',  { italic = true })
hl('@markup.link',    { fg = blue, underline = true })
hl('@markup.raw',     { fg = green })
hl('@markup.quote',   { fg = dim_fg, italic = true })
