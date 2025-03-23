local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

-- used to paste visual selection, inside of dynamic nodes
local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

return {

  s({ trig = 'co', name = '[co]mmand', desc = 'LaTeX command', wordTrig = false },
  fmta(
    [[\<>]],
    { d(1, get_visual) }
    )
  ),

  s({ trig = 'com', name = '[com]mand with argument', desc = 'LaTeX command with argument', wordTrig = false },
  fmta(
    [[\<>{<>}<>]],
    { i(1), d(2, get_visual), i(0) }
    )
  ),

  s({ trig = 'cop', name = '[co]mmand with argument and [p]arameter', desc = 'LaTeX command with argument and parameter', wordTrig = false },
  fmta(
    [[\<>[<>]{<>}<>]],
    { i(1), i(3), d(2, get_visual), i(0) }
    )
  ),

  s({ trig = 'ba', name = '[b]racketed [a]rgument', wordTrig = false },
  fmta(
    [[{ <> }]],
    { d(1, get_visual) }
    )
  ),

  s({ trig = 'up', name = '[u]se [p]ackage', desc = 'include package', wordTrig = false },
  fmta(
    [[\usepackage{<>}]],
    { i(1) }
    )
  ),

  s({ trig = 'upp', name = '[u]se [p]ackage with [p]arameters', desc = 'include package with parameters', wordTrig = false },
  fmta(
    [[\usepackage[<>]{<>}]],
    { i(2), i(1) }
    )
  ),

  s({ trig = 'be', name = '[b]egin [e]nvironment', desc = 'LaTeX environment', wordTrig = false },
  fmta(
    [[
    \begin{<>}
      <>
    \end{<>}
    ]],
    { i(1), d(2, get_visual), rep(1) }
    )
  ),

  s({ trig = 'bep', name = '[b]egin [e]nvironment with [p]arameters', desc = 'LaTeX environment with parameters', wordTrig = false },
  fmta(
    [[
    \begin[<>]{<>}
      <>
    \end{<>}
    ]],
    { i(1), i(2), d(3, get_visual), rep(1) }
    )
  ),

  s({ trig = 'im', name = '[i]nline [m]ath', wordTrig = false },
  fmta(
    [[\( <> \)]],
    { d(1, get_visual) }
    )
  ),

}
