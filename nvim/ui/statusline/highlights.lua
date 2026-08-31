---@diagnostic disable: undefined-global

for mode, color in pairs({
	Normal = magenta, Insert = blue, Visual = red,
	Replace = yellow, Command = green, Terminal = cyan,
}) do
	hl('StlMode' .. mode, { fg = dim_bg, bg = color, bold = true })
end

link('StlTabActive', 'UiSelected')
link('StlTabInactive', 'UiSurfaceMuted')
