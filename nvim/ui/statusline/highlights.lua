---@diagnostic disable: undefined-global

for mode, color in pairs({
	Normal = magenta, Insert = blue, Visual = red,
	Replace = yellow, Command = green, Terminal = cyan,
}) do
	hl('StlMode' .. mode, { fg = dim_bg, bg = color, bold = true })
end

hl("StlDiagnosticError", {fg = red})
hl("StlDiagnosticWarn", {fg = yellow})
hl("StlDiagnosticInfo", {fg = blue})
hl("StlDiagnosticHint", {fg = cyan})
