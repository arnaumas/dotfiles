" vimtex matches '|' together with the real operators (+ - = / < >) in a single
" texMathOper pattern, so a colorscheme can't tell them apart. Split the pipe
" into its own group (defined after core syntax, so it wins at a '|' position)
" and add it to the math cluster. Highlighting is set in colors/light.lua
" (texMathPipe -> Normal), so pipes read as plain text while operators stay green.
syntax match texMathPipe "[|]" contained display
syntax cluster texClusterMath add=texMathPipe
