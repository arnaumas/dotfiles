vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end
vim.g.colors_name = 'ansi'

local fg, dim_fg, bg, dim_bg = 0, 7, 8, 15
local red, green, yellow, blue, magenta, cyan = 1, 2, 3, 4, 5, 6
local red_bg, green_bg, yellow_bg, blue_bg, magenta_bg, cyan_bg = 9, 10, 11, 12, 13, 14
local accent, accent_bg = green, green_bg
local selection_fg, selection_bg = fg, bg

local function hl(group, s)
	vim.api.nvim_set_hl(0, group, {
		ctermfg = s.fg, ctermbg = s.bg,
		bold = s.bold, italic = s.italic,
		underline = s.underline, undercurl = s.undercurl,
		strikethrough = s.strike,
	})
end
local function link(from, to) vim.api.nvim_set_hl(0, from, { link = to }) end

hl('UiMuted',        { fg = dim_fg })
hl('UiSurface',      { fg = fg,     bg = dim_bg })
hl('UiSurfaceMuted', { fg = dim_fg, bg = dim_bg })
hl('UiSelected',     { fg = fg,     bg = bg, bold = true })
hl('UiAccent',       { fg = accent, bold = true })
hl('UiAccentBg',     { fg = fg,     bg = accent_bg, bold = true })

for _, g in ipairs({
	'Normal', 'NormalNC', 'SignColumn', 'Folded', 'TabLineFill',
}) do hl(g, {}) end
for _, g in ipairs({
	'EndOfBuffer', 'LineNr', 'LineNrAbove', 'LineNrBelow', 'FoldColumn',
	'WinSeparator', 'VertSplit', 'NonText', 'Whitespace', 'SpecialKey', 'Conceal',
	'ModeMsg', 'MsgSeparator',
}) do link(g, 'UiMuted') end

hl('CursorLine',   { bg = dim_bg })
link('CursorLineNr', 'UiAccent')
hl('CursorColumn', { bg = dim_bg })
hl('ColorColumn',  { bg = bg })
hl('FoldEllipsis', { fg = dim_fg, bg = bg, bold = true })

hl('Visual', { fg = selection_fg, bg = selection_bg })
link('VisualNOS', 'Visual')

hl('Search',    { fg = yellow, bg = bg,        bold = true })
hl('IncSearch', { fg = yellow, bg = yellow_bg, bold = true })
link('CurSearch', 'IncSearch')
hl('MatchParen', { fg = accent, bold = true, underline = true })

link('Pmenu', 'UiSurfaceMuted')
link('PmenuSel', 'UiSelected')
link('PmenuSbar',  'Pmenu')
link('PmenuThumb', 'Pmenu')
hl('PmenuKind',  { fg = blue })
hl('PmenuExtra', { fg = dim_fg })

link('StatusLine', 'UiSurface')
link('StatusLineNC', 'UiSurfaceMuted')
hl('TabLine', { fg = dim_fg, bg = bg })
link('TabLineSel', 'UiAccentBg')
link('WildMenu', 'UiAccentBg')
hl('WinBarNC', { fg = dim_fg, bg = bg })

link('NormalFloat', 'UiSurface')
hl('FloatBorder', { bg = dim_bg })
hl('FloatTitle',  { bg = bg, bold = true })
link('WinBar', 'FloatTitle')

hl('Title',        { fg = blue, bold = true })
hl('Directory',    { fg = blue })
hl('QuickFixLine', { bg = bg, bold = true })
hl('ErrorMsg',   { fg = red })
hl('WarningMsg', { fg = yellow })
hl('MoreMsg',    { fg = green })
hl('Question',   { fg = green })
for _, g in ipairs({ 'SpellBad', 'SpellCap', 'SpellRare', 'SpellLocal' }) do
	hl(g, { undercurl = true })
end

for _, g in ipairs({
	'Identifier', 'Statement', 'Keyword', 'Conditional', 'Repeat', 'Label', 'Exception',
	'PreProc', 'Include', 'Define', 'Macro', 'PreCondit',
	'Type', 'StorageClass', 'Structure', 'Typedef',
}) do hl(g, {}) end

hl('Comment', { fg = yellow, italic = true })
for _, g in ipairs({ 'String', 'Character', 'Number', 'Float' }) do hl(g, { fg = green }) end
for _, g in ipairs({ 'Boolean', 'Constant' }) do hl(g, { fg = magenta }) end
hl('Function', { fg = blue })
hl('Tag',      { fg = blue })
hl('SpecialChar', { fg = cyan })
hl('Delimiter', { fg = dim_fg })
for _, g in ipairs({ 'Operator', 'Special', 'Debug' }) do link(g, 'Delimiter') end
hl('Todo',       { fg = yellow, bold = true })
hl('Error',      { fg = red })
hl('Underlined', { fg = blue, underline = true })

hl('DiffAdd',    { fg = green })
hl('DiffChange', { fg = yellow })
hl('DiffDelete', { fg = red })
hl('DiffText',   { fg = fg, bg = blue_bg })

link('MsgArea', 'Normal')
