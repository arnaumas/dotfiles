---@diagnostic disable: undefined-global

for _, g in ipairs({ 'texCmd', 'texCmdStyle', 'texEnvArgName', 'texMathEnvArgName' }) do
	hl(g, { fg = blue })
end
for _, g in ipairs({ 'texDelim', 'texTabularChar', 'texMathSuperSub', 'texSpecialChar' }) do
	link(g, 'Delimiter')
end
hl('texMathOper', { fg = green })
for _, g in ipairs({ 'texPartArgTitle', 'texTitleArg' }) do hl(g, { fg = blue, bold = true }) end
for _, g in ipairs({ 'texRefArg', 'texRefConcealedArg', 'texRefEqConcealedArg' }) do
	hl(g, { fg = cyan })
end

for _, g in ipairs({
	'texMathZone', 'texMathZoneTI', 'texMathZoneTD', 'texMathZoneLI', 'texMathZoneLD', 'texMathZoneEnv',
	'texMathArg', 'texMathGroup', 'texMathSub', 'texMathSuper', 'texMathDelim', 'texMathPipe',
	'texStyleBold', 'texStyleItal', 'texStyleUnder', 'texStyleBoth',
	'texStyleBoldUnder', 'texStyleItalUnder', 'texStyleBoldItalUnder', 'texStyleArgConc',
	'texOpt', 'texEnvOpt', 'texRefConcealedOpt1',
}) do link(g, 'Normal') end
