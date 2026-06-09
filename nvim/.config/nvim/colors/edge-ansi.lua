-- edge-ansi: minimal, semantic colorscheme anchored to the terminal's 16 ANSI
-- colors. Highlighting follows tonsky.me/blog/syntax-highlighting/: color
-- strings/numbers (green), constants (magenta), comments (yellow, not grey),
-- definitions (blue); grey out punctuation; leave keywords and ordinary
-- variables/calls in the default foreground. UI/active elements use the green
-- accent + brighter ANSI tier (9-14). Needs notermguicolors (plugin/10_options).

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end
vim.g.colors_name = 'edge-ansi'

-- ANSI slots; the actual hex lives in the iterm profile.
local grey, red, green, yellow, blue, magenta, cyan, sel = 8, 1, 2, 3, 4, 5, 6, 7
local bred, bgreen, byellow, bblue, bmagenta, bcyan, white = 9, 10, 11, 12, 13, 14, 15
local faint = white   -- slot 15: faintest grey surface (lighter than sel=7)
local accent = bgreen -- UI accent (titles, prompts, selection, focused)

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
	Normal = {}, NormalNC = {}, EndOfBuffer = { fg = grey },
	-- gutter stays transparent; current line number pops via the accent
	LineNr = { fg = grey }, LineNrAbove = { fg = grey }, LineNrBelow = { fg = grey },
	CursorLine = { bg = faint }, CursorLineNr = { fg = accent, bold = true },
	CursorColumn = { bg = faint }, ColorColumn = { bg = sel },
	SignColumn = {}, FoldColumn = { fg = grey },
	Folded = { bg = sel },
	Visual = { bg = grey }, VisualNOS = { bg = grey },
	-- search: current match under cursor = yellow; other matches = grey bg
	Search = { bg = grey }, IncSearch = { fg = 0, bg = bgreen }, CurSearch = { fg = 0, bg = bgreen },
	MatchParen = { fg = accent, bold = true, underline = true },
	Pmenu = { bg = sel }, PmenuSel = { fg = white, bg = accent, bold = true },
	PmenuSbar = { bg = sel }, PmenuThumb = { bg = grey },
	PmenuKind = { fg = blue, bg = sel }, PmenuExtra = { fg = grey, bg = sel },
	StatusLine = { bg = sel }, StatusLineNC = { fg = grey },
	TabLine = { fg = grey, bg = sel }, TabLineSel = { fg = white, bg = accent, bold = true }, TabLineFill = {},
	WinSeparator = { fg = grey }, VertSplit = { fg = grey },
	NonText = { fg = grey }, Whitespace = { fg = grey }, SpecialKey = { fg = grey }, Conceal = { fg = grey },
	Title = { fg = blue, bold = true }, Directory = { fg = blue },
	QuickFixLine = { bg = sel, bold = true },
	ErrorMsg = { fg = bred }, WarningMsg = { fg = byellow }, ModeMsg = { fg = grey }, MoreMsg = { fg = green },
	Question = { fg = green }, MsgSeparator = { fg = grey },
	FloatBorder = { fg = grey }, FloatTitle = { fg = accent, bold = true },
	WildMenu = { fg = white, bg = accent, bold = true },
	SpellBad = { undercurl = true }, SpellCap = { undercurl = true },
	SpellRare = { undercurl = true }, SpellLocal = { undercurl = true },

	-- syntax (legacy groups; calm by default, color only what carries meaning)
	Comment = { fg = yellow, italic = true },
	String = { fg = green }, Character = { fg = green },
	Number = { fg = green }, Float = { fg = green },
	Boolean = { fg = magenta }, Constant = { fg = magenta },
	Identifier = {}, Function = { fg = blue },
	Statement = {}, Keyword = {}, Conditional = {}, Repeat = {}, Label = {}, Exception = {},
	Operator = { fg = grey },
	PreProc = {}, Include = {}, Define = {}, Macro = {}, PreCondit = {},
	Type = {}, StorageClass = {}, Structure = {}, Typedef = {},
	Special = { fg = grey }, SpecialChar = { fg = cyan }, Delimiter = { fg = grey },
	Tag = { fg = blue }, Debug = { fg = grey },
	Todo = { fg = byellow, bold = true }, Error = { fg = bred },
	Underlined = { fg = blue, underline = true },

	-- treesitter (dormant insurance; only applies if you enable TS highlight)
	['@comment'] = { fg = yellow, italic = true },
	['@comment.error'] = { fg = bred, bold = true }, ['@comment.warning'] = { fg = byellow, bold = true },
	['@comment.todo'] = { fg = bblue, bold = true }, ['@comment.note'] = { fg = bcyan, bold = true },
	['@string'] = { fg = green }, ['@string.escape'] = { fg = cyan }, ['@string.special'] = { fg = cyan },
	['@character'] = { fg = green }, ['@number'] = { fg = green }, ['@boolean'] = { fg = magenta },
	['@constant'] = { fg = magenta }, ['@constant.builtin'] = { fg = magenta }, ['@constant.macro'] = { fg = magenta },
	['@function'] = { fg = blue }, ['@function.call'] = {}, ['@function.builtin'] = {},
	['@function.method'] = { fg = blue }, ['@function.method.call'] = {}, ['@constructor'] = { fg = blue },
	['@keyword'] = {}, ['@conditional'] = {}, ['@repeat'] = {}, ['@operator'] = { fg = grey },
	['@variable'] = {}, ['@variable.builtin'] = { fg = magenta }, ['@variable.parameter'] = {}, ['@variable.member'] = {},
	['@property'] = {}, ['@field'] = {}, ['@type'] = {}, ['@type.builtin'] = {}, ['@type.definition'] = { fg = blue },
	['@punctuation.delimiter'] = { fg = grey }, ['@punctuation.bracket'] = { fg = grey }, ['@punctuation.special'] = { fg = grey },
	['@module'] = {}, ['@namespace'] = {}, ['@attribute'] = { fg = cyan }, ['@label'] = { fg = grey },
	['@tag'] = { fg = blue }, ['@tag.attribute'] = {}, ['@tag.delimiter'] = { fg = grey },
	['@markup.heading'] = { fg = blue, bold = true }, ['@markup.strong'] = { bold = true }, ['@markup.italic'] = { italic = true },
	['@markup.link'] = { fg = blue, underline = true }, ['@markup.raw'] = { fg = green },
	['@markup.list'] = { fg = grey }, ['@markup.quote'] = { fg = grey, italic = true },

	-- LSP semantic tokens (Lua via lua_ls): definitions blue, consts magenta, rest calm
	['@lsp.type.function'] = {}, ['@lsp.type.method'] = {},
	['@lsp.typemod.function.declaration'] = { fg = blue }, ['@lsp.typemod.method.declaration'] = { fg = blue },
	['@lsp.type.parameter'] = {}, ['@lsp.type.variable'] = {}, ['@lsp.type.property'] = {},
	['@lsp.type.namespace'] = {}, ['@lsp.type.keyword'] = {},
	['@lsp.type.enumMember'] = { fg = magenta }, ['@lsp.typemod.variable.readonly'] = { fg = magenta },
	['@lsp.type.string'] = { fg = green }, ['@lsp.type.number'] = { fg = green },

	-- diagnostics
	DiagnosticError = { fg = bred }, DiagnosticWarn = { fg = byellow },
	DiagnosticInfo = { fg = bblue }, DiagnosticHint = { fg = bcyan }, DiagnosticOk = { fg = bgreen },
	DiagnosticUnderlineError = { undercurl = true }, DiagnosticUnderlineWarn = { undercurl = true },
	DiagnosticUnderlineInfo = { undercurl = true }, DiagnosticUnderlineHint = { undercurl = true },
	LspInlayHint = { fg = grey }, LspCodeLens = { fg = grey },
	LspReferenceText = { bg = sel }, LspReferenceRead = { bg = sel }, LspReferenceWrite = { bg = sel },
	LspSignatureActiveParameter = { fg = byellow, bold = true },

	-- diff / git signs
	DiffAdd = { fg = bgreen }, DiffChange = { fg = byellow }, DiffDelete = { fg = bred }, DiffText = { fg = white, bg = bblue },
	MiniDiffSignAdd = { fg = bgreen }, MiniDiffSignChange = { fg = byellow }, MiniDiffSignDelete = { fg = bred },

	-- mini.statusline: modes use edge's normal (not bright) hues with white text;
	-- section text stays at full foreground (readable) on a grey bg, as in edge.
	MiniStatuslineModeNormal = { fg = white, bg = magenta, bold = true },
	MiniStatuslineModeInsert = { fg = white, bg = blue, bold = true },
	MiniStatuslineModeVisual = { fg = white, bg = red, bold = true },
	MiniStatuslineModeReplace = { fg = white, bg = yellow, bold = true },
	MiniStatuslineModeCommand = { fg = white, bg = green, bold = true },
	MiniStatuslineModeOther = { fg = white, bg = cyan, bold = true },
	MiniStatuslineDevinfo = { bg = sel }, MiniStatuslineFileinfo = { bg = sel },
	MiniStatuslineFilename = { bg = sel }, MiniStatuslineInactive = { fg = grey },

	-- mini.pick / files / tabline / notify / icons
	MiniPickNormal = {},
	MiniPickBorder = { fg = grey }, MiniPickBorderText = { fg = accent, bold = true },
	MiniPickPrompt = { fg = accent, bold = true }, MiniPickPromptCaret = { fg = accent },
	MiniPickMatchCurrent = { bg = sel }, MiniPickMatchMarked = { fg = bmagenta },
	MiniPickMatchRanges = { fg = byellow, bold = true }, MiniPickHeader = { fg = blue },
	MiniFilesBorder = { fg = grey }, MiniFilesBorderModified = { fg = byellow },
	MiniFilesTitle = { fg = grey }, MiniFilesTitleFocused = { fg = accent, bold = true },
	MiniFilesDirectory = { fg = blue }, MiniFilesCursorLine = { bg = sel },
	-- tabs: normal text on grey (like the statusline); current = sel (darker),
	-- visible/hidden = faint grey; modified shown with italic
	MiniTablineCurrent = { bg = sel, bold = true },
	MiniTablineVisible = { bg = faint }, MiniTablineHidden = { fg = grey, bg = faint },
	MiniTablineModifiedCurrent = { bg = sel, bold = true, italic = true },
	MiniTablineModifiedVisible = { bg = faint, italic = true }, MiniTablineModifiedHidden = { fg = grey, bg = faint, italic = true },
	MiniTablineTabpagesection = { fg = white, bg = blue, bold = true }, MiniTablineFill = {},
	MiniNotifyNormal = {}, MiniNotifyBorder = { fg = grey }, MiniNotifyTitle = { fg = accent, bold = true },
	MiniIconsAzure = { fg = blue }, MiniIconsBlue = { fg = bblue }, MiniIconsCyan = { fg = cyan },
	MiniIconsGreen = { fg = green }, MiniIconsGrey = { fg = grey }, MiniIconsOrange = { fg = byellow },
	MiniIconsPurple = { fg = magenta }, MiniIconsRed = { fg = bred }, MiniIconsYellow = { fg = yellow },

	-- blink.cmp
	BlinkCmpMenuBorder = { fg = grey }, BlinkCmpScrollBarThumb = { bg = grey }, BlinkCmpScrollBarGutter = { bg = sel },
	BlinkCmpLabelMatch = { fg = byellow, bold = true }, BlinkCmpLabelDeprecated = { fg = grey, strike = true },
	BlinkCmpLabelDetail = { fg = grey }, BlinkCmpLabelDescription = { fg = grey },
	BlinkCmpKind = { fg = blue }, BlinkCmpGhostText = { fg = grey },
	BlinkCmpDocBorder = { fg = grey }, BlinkCmpSignatureHelpBorder = { fg = grey },
	BlinkCmpSignatureHelpActiveParameter = { fg = byellow, bold = true },

	-- vimtex / LaTeX (mapped from actual group names). A command is a single token
	-- (backslash + name), so the whole \name is blue; braces/brackets/fences dim
	-- grey; operators pop green; plain math letters + optional args read as prose;
	-- titles pop blue, citations/refs pop cyan. (math content -> Normal, in links.)
	texComment      = { fg = yellow, italic = true },
	texCmd          = { fg = blue },    -- all \commands, prose + math (greek, symbols, \section, \cite, ...)
	texCmdStyle     = { fg = blue },    -- \texttt \textsc \textrm \textsf (link to texCmdType, not texCmd)
	texEnvArgName   = { fg = blue }, texMathEnvArgName = { fg = blue }, -- environment names
	texDelim        = { fg = grey },    -- { } [ ] braces/brackets
	texTabularChar  = { fg = grey },    -- & alignment char (dim like braces)
	texMathSuperSub = { fg = grey },    -- _ ^ markers + their { } (dimmed like braces)
	texMathOper     = { fg = green },   -- + - = operators (NOTE: also covers | pipes)
	texSpecialChar  = { fg = grey },    -- ~ \, etc.
	-- section/chapter/\title titles pop:
	texPartArgTitle = { fg = blue, bold = true }, texTitleArg = { fg = blue, bold = true },
	-- citations & references pop:
	texRefArg = { fg = cyan }, texRefConcealedArg = { fg = cyan }, texRefEqConcealedArg = { fg = cyan },
	-- (text-style command contents, texStyleBold/Ital/..., link to Normal below)
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
