-- ansi: minimal, semantic colorscheme anchored to the terminal's 16 ANSI
-- colors. Highlighting follows tonsky.me/blog/syntax-highlighting/: color
-- strings/numbers (green), constants (magenta), comments (yellow, not grey),
-- definitions (blue); grey out punctuation; leave keywords and ordinary
-- variables/calls in the default foreground. Emphasis uses a hue's muted
-- background tier (*_bg, slots 9-14) behind fg text, not a brighter fg.
-- Polarity (light/dark) is the terminal's job: each slot's ROLE is fixed here,
-- only the hex behind it flips (see colors/*.yaml). Needs notermguicolors
-- (plugin/10_options).

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end
vim.g.colors_name = 'ansi'

-- palette: semantic role -> ANSI slot. Only place slot numbers live; the grays
-- are named by role because the literal names lie under inversion (in the dark
-- scheme slot 0 "black" holds a light color). Hues stay literal: normal (1-6)
-- for foreground text, *_bg (9-14) as muted "transparency" backgrounds. The
-- actual hex lives in colors/*.yaml, set by the terminal.
local fg, dim_fg, bg, dim_bg = 0, 8, 7, 15
local red, green, yellow, blue, magenta, cyan = 1, 2, 3, 4, 5, 6
local red_bg, green_bg, yellow_bg, blue_bg, magenta_bg, cyan_bg = 9, 10, 11, 12, 13, 14
local accent, accent_bg = green, green_bg          -- UI accent (titles, prompts, focused)
local selection_fg, selection_bg = fg, dim_fg      -- visual mode: uniform fg on the dim surface

local function hl(group, s)
	vim.api.nvim_set_hl(0, group, {
		ctermfg = s.fg, ctermbg = s.bg,
		bold = s.bold, italic = s.italic,
		underline = s.underline, undercurl = s.undercurl, strikethrough = s.strike,
	})
end
local function link(from, to) vim.api.nvim_set_hl(0, from, { link = to }) end
local groups = {
	-- editor UI
	Normal = {}, NormalNC = {}, EndOfBuffer = { fg = dim_fg },
	-- gutter stays transparent; current line number pops via the accent
	LineNr = { fg = dim_fg }, LineNrAbove = { fg = dim_fg }, LineNrBelow = { fg = dim_fg },
	CursorLine = { bg = dim_bg }, CursorLineNr = { fg = accent, bold = true },
	CursorColumn = { bg = dim_bg }, ColorColumn = { bg = bg },
	SignColumn = {}, FoldColumn = { fg = dim_fg },
	Folded = { bg = bg },
	-- visual selection: uniform fg over the dim surface (kills syntax-color noise)
	Visual = { fg = selection_fg, bg = selection_bg }, VisualNOS = { fg = selection_fg, bg = selection_bg },
	-- search: current match under cursor = yellow; other matches = dim grey bg
	Search = { bg = dim_fg }, IncSearch = { fg = fg, bg = yellow_bg }, CurSearch = { fg = fg, bg = yellow_bg },
	MatchParen = { fg = accent, bold = true, underline = true },
	Pmenu = { fg = dim_fg, bg = dim_bg }, PmenuSel = { fg = fg, bg = bg, bold = true },
	PmenuSbar = { bg = bg }, PmenuThumb = { bg = dim_fg },
	PmenuKind = { fg = blue, bg = bg }, PmenuExtra = { fg = dim_fg, bg = bg },
	StatusLine = { bg = dim_bg, fg = fg }, StatusLineNC = { bg = dim_bg, fg = dim_fg },
	TabLine = { fg = dim_fg, bg = bg }, TabLineSel = { fg = fg, bg = accent_bg, bold = true }, TabLineFill = {},
	WinSeparator = { fg = dim_fg }, VertSplit = { fg = dim_fg },
	NonText = { fg = dim_fg }, Whitespace = { fg = dim_fg }, SpecialKey = { fg = dim_fg }, Conceal = { fg = dim_fg },
	Title = { fg = blue, bold = true }, Directory = { fg = blue },
	QuickFixLine = { bg = bg, bold = true },
	ErrorMsg = { fg = red }, WarningMsg = { fg = yellow }, ModeMsg = { fg = dim_fg }, MoreMsg = { fg = green },
	Question = { fg = green }, MsgSeparator = { fg = dim_fg },
	FloatBorder = { fg = dim_fg }, FloatTitle = { fg = accent, bold = true },
	WildMenu = { fg = fg, bg = accent_bg, bold = true },
	SpellBad = { undercurl = true }, SpellCap = { undercurl = true },
	SpellRare = { undercurl = true }, SpellLocal = { undercurl = true },

	-- status line
	StlModeNormal   = { fg = dim_bg, bg = magenta, bold = true },
	StlModeInsert   = { fg = dim_bg, bg = blue,    bold = true },
	StlModeVisual   = { fg = dim_bg, bg = red,     bold = true },
	StlModeReplace  = { fg = dim_bg, bg = yellow,  bold = true },
	StlModeCommand  = { fg = dim_bg, bg = green,   bold = true },
	StlModeTerminal = { fg = dim_bg, bg = cyan,    bold = true },
	-- tabs
	StlTabActive   = { fg = fg, bg = bg, bold = true },
	StlTabInactive = { fg = fg, bg = dim_bg },

	-- syntax
	Comment = { fg = yellow, italic = true },
	String = { fg = green }, Character = { fg = green },
	Number = { fg = green }, Float = { fg = green },
	Boolean = { fg = magenta }, Constant = { fg = magenta },
	Identifier = {}, Function = { fg = blue },
	Statement = {}, Keyword = {}, Conditional = {}, Repeat = {}, Label = {}, Exception = {},
	Operator = { fg = dim_fg },
	PreProc = {}, Include = {}, Define = {}, Macro = {}, PreCondit = {},
	Type = {}, StorageClass = {}, Structure = {}, Typedef = {},
	Special = { fg = dim_fg }, SpecialChar = { fg = cyan }, Delimiter = { fg = dim_fg },
	Tag = { fg = blue }, Debug = { fg = dim_fg },
	Todo = { fg = yellow, bold = true }, Error = { fg = red },
	Underlined = { fg = blue, underline = true },

	-- treesitter
	['@comment'] = { fg = yellow, italic = true },
	['@comment.error'] = { fg = red, bold = true }, ['@comment.warning'] = { fg = yellow, bold = true },
	['@comment.todo'] = { fg = blue, bold = true }, ['@comment.note'] = { fg = cyan, bold = true },
	['@string'] = { fg = green }, ['@string.escape'] = { fg = cyan }, ['@string.special'] = { fg = cyan },
	['@character'] = { fg = green }, ['@number'] = { fg = green }, ['@boolean'] = { fg = magenta },
	['@constant'] = { fg = magenta }, ['@constant.builtin'] = { fg = magenta }, ['@constant.macro'] = { fg = magenta },
	['@function'] = { fg = blue }, ['@function.call'] = {}, ['@function.builtin'] = {},
	['@function.method'] = { fg = blue }, ['@function.method.call'] = {}, ['@constructor'] = { fg = blue },
	['@keyword'] = {}, ['@conditional'] = {}, ['@repeat'] = {}, ['@operator'] = { fg = dim_fg },
	['@variable'] = {}, ['@variable.builtin'] = { fg = magenta }, ['@variable.parameter'] = {}, ['@variable.member'] = {},
	['@property'] = {}, ['@field'] = {}, ['@type'] = {}, ['@type.builtin'] = {}, ['@type.definition'] = { fg = blue },
	['@punctuation.delimiter'] = { fg = dim_fg }, ['@punctuation.bracket'] = { fg = dim_fg }, ['@punctuation.special'] = { fg = dim_fg },
	['@module'] = {}, ['@namespace'] = {}, ['@attribute'] = { fg = cyan }, ['@label'] = { fg = dim_fg },
	['@tag'] = { fg = blue }, ['@tag.attribute'] = {}, ['@tag.delimiter'] = { fg = dim_fg },
	['@markup.heading'] = { fg = blue, bold = true }, ['@markup.strong'] = { bold = true }, ['@markup.italic'] = { italic = true },
	['@markup.link'] = { fg = blue, underline = true }, ['@markup.raw'] = { fg = green },
	['@markup.list'] = { fg = dim_fg }, ['@markup.quote'] = { fg = dim_fg, italic = true },

	-- LSP semantic tokens 
	['@lsp.type.function'] = {}, ['@lsp.type.method'] = {},
	['@lsp.typemod.function.declaration'] = { fg = blue }, ['@lsp.typemod.method.declaration'] = { fg = blue },
	['@lsp.type.parameter'] = {}, ['@lsp.type.variable'] = {}, ['@lsp.type.property'] = {},
	['@lsp.type.namespace'] = {}, ['@lsp.type.keyword'] = {},
	['@lsp.type.enumMember'] = { fg = magenta }, ['@lsp.typemod.variable.readonly'] = { fg = magenta },
	['@lsp.type.string'] = { fg = green }, ['@lsp.type.number'] = { fg = green },

	-- diagnostics
	DiagnosticError = { fg = red }, DiagnosticWarn = { fg = yellow },
	DiagnosticInfo = { fg = blue }, DiagnosticHint = { fg = cyan }, DiagnosticOk = { fg = green },
	DiagnosticUnderlineError = { undercurl = true }, DiagnosticUnderlineWarn = { undercurl = true },
	DiagnosticUnderlineInfo = { undercurl = true }, DiagnosticUnderlineHint = { undercurl = true },
	LspInlayHint = { fg = dim_fg }, LspCodeLens = { fg = dim_fg },
	LspReferenceText = { bg = bg }, LspReferenceRead = { bg = bg }, LspReferenceWrite = { bg = bg },
	LspSignatureActiveParameter = { fg = yellow, bold = true },

	-- diff / git signs
	DiffAdd = { fg = green }, DiffChange = { fg = yellow }, DiffDelete = { fg = red }, DiffText = { fg = fg, bg = blue_bg },
	MiniDiffSignAdd = { fg = green }, MiniDiffSignChange = { fg = yellow }, MiniDiffSignDelete = { fg = red },

	-- mini.pick / files / notify / icons
	MiniFilesBorder = { fg = dim_fg }, MiniFilesBorderModified = { fg = yellow },
	MiniFilesTitle = { fg = dim_fg }, MiniFilesTitleFocused = { fg = accent, bold = true },
	MiniFilesDirectory = { fg = blue }, MiniFilesCursorLine = { bg = bg },
	MiniNotifyNormal = {}, MiniNotifyBorder = { fg = dim_fg }, MiniNotifyTitle = { fg = accent, bold = true },
	MiniIconsAzure = { fg = blue }, MiniIconsBlue = { fg = blue }, MiniIconsCyan = { fg = cyan },
	MiniIconsGreen = { fg = green }, MiniIconsGrey = { fg = dim_fg }, MiniIconsOrange = { fg = yellow },
	MiniIconsPurple = { fg = magenta }, MiniIconsRed = { fg = red }, MiniIconsYellow = { fg = yellow },

	-- blink.cmp
	BlinkCmpMenuBorder = { fg = dim_fg }, BlinkCmpScrollBarThumb = { bg = dim_fg }, BlinkCmpScrollBarGutter = { bg = bg },
	BlinkCmpLabelMatch = { fg = yellow, bold = true }, BlinkCmpLabelDeprecated = { fg = dim_fg, strike = true },
	BlinkCmpLabelDetail = { fg = dim_fg }, BlinkCmpLabelDescription = { fg = dim_fg },
	BlinkCmpKind = { fg = blue }, BlinkCmpGhostText = { fg = dim_fg },
	BlinkCmpDocBorder = { fg = dim_fg }, BlinkCmpSignatureHelpBorder = { fg = dim_fg },
	BlinkCmpSignatureHelpActiveParameter = { fg = yellow, bold = true },

	-- vimtex
	texCmd          = { fg = blue },    -- all \commands, prose + math (greek, symbols, \section, \cite, ...)
	texCmdStyle     = { fg = blue },    -- \texttt \textsc \textrm \textsf (link to texCmdType, not texCmd)
	texEnvArgName   = { fg = blue }, texMathEnvArgName = { fg = blue }, -- environment names
	texDelim        = { fg = dim_fg },  -- { } [ ] braces/brackets
	texTabularChar  = { fg = dim_fg },  -- & alignment char (dim like braces)
	texMathSuperSub = { fg = dim_fg },  -- _ ^ markers + their { } (dimmed like braces)
	texMathOper     = { fg = green },   -- + - = operators (NOTE: also covers | pipes)
	texSpecialChar  = { fg = dim_fg },  -- ~ \, etc.
	-- section/chapter/\title titles pop:
	texPartArgTitle = { fg = blue, bold = true }, texTitleArg = { fg = blue, bold = true },
	-- citations & references pop:
	texRefArg = { fg = cyan }, texRefConcealedArg = { fg = cyan }, texRefEqConcealedArg = { fg = cyan },
	-- (text-style command contents, texStyleBold/Ital/..., link to Normal below)

	-- zsh (built-in syntax; no treesitter parser). Tonsky: definitions blue.
	-- Covers name() (zshFunction) and `function name` (zshKSHFunction links here).
	zshFunction = { fg = blue },
}
for g, s in pairs(groups) do hl(g, s) end

local links = {
	['@lsp.type.comment'] = 'Comment',
	-- LaTeX: all math content (letters, \frac args, every math zone), parens/fences
	-- and optional-arg names read as prose (default fg)
	texMathZone = 'Normal', texMathZoneTI = 'Normal', texMathZoneTD = 'Normal',
	texMathZoneLI = 'Normal', texMathZoneLD = 'Normal', texMathZoneEnv = 'Normal',
	texMathArg = 'Normal', texMathGroup = 'Normal', texMathSub = 'Normal', texMathSuper = 'Normal',
	texMathDelim = 'Normal',
	texMathPipe = 'Normal', -- '|' split out of texMathOper (see after/syntax/tex.vim)
	-- text-style command contents read as plain prose (no special fg/attrs)
	texStyleBold = 'Normal', texStyleItal = 'Normal', texStyleUnder = 'Normal', texStyleBoth = 'Normal',
	texStyleBoldUnder = 'Normal', texStyleItalUnder = 'Normal', texStyleBoldItalUnder = 'Normal',
	texStyleArgConc = 'Normal',
	texOpt = 'Normal', texEnvOpt = 'Normal', texRefConcealedOpt1 = 'Normal',
	NormalFloat = 'Normal', MsgArea = 'Normal',
	DiagnosticSignError = 'DiagnosticError', DiagnosticSignWarn = 'DiagnosticWarn',
	DiagnosticSignInfo = 'DiagnosticInfo', DiagnosticSignHint = 'DiagnosticHint',
	DiagnosticVirtualTextError = 'DiagnosticError', DiagnosticVirtualTextWarn = 'DiagnosticWarn',
	DiagnosticVirtualTextInfo = 'DiagnosticInfo', DiagnosticVirtualTextHint = 'DiagnosticHint',
	DiagnosticFloatingError = 'DiagnosticError', DiagnosticFloatingWarn = 'DiagnosticWarn',
	DiagnosticFloatingInfo = 'DiagnosticInfo', DiagnosticFloatingHint = 'DiagnosticHint',
	BlinkCmpMenu = 'Pmenu', BlinkCmpMenuSelection = 'PmenuSel', BlinkCmpDoc = 'Pmenu', BlinkCmpSignatureHelp = 'Pmenu',
}
for from, to in pairs(links) do link(from, to) end
