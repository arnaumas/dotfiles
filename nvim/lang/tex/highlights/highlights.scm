; extends

([
  (operator)
  "="
] @operator.math
  (#in-math? @operator.math))
(superscript
  "^" @operator.math)
(subscript
  "_" @operator.math)

((command_name) @markup.math.symbol
  (#in-math? @markup.math.symbol)
  (#set! "priority" 105)
  (#any-of? @markup.math.symbol
    "\\alpha" "\\beta" "\\gamma" "\\delta" "\\epsilon" "\\varepsilon" "\\zeta" "\\eta"
    "\\theta" "\\vartheta" "\\iota" "\\kappa" "\\lambda" "\\mu" "\\nu" "\\xi" "\\pi"
    "\\varpi" "\\rho" "\\varrho" "\\sigma" "\\varsigma" "\\tau" "\\upsilon" "\\phi"
    "\\varphi" "\\chi" "\\psi" "\\omega"
    "\\Gamma" "\\Delta" "\\Theta" "\\Lambda" "\\Xi" "\\Pi" "\\Sigma" "\\Upsilon"
    "\\Phi" "\\Psi" "\\Omega"
    "\\nabla" "\\partial" "\\infty" "\\emptyset" "\\varnothing" "\\ell" "\\hbar"
    "\\Re" "\\Im" "\\aleph" "\\wp" "\\forall" "\\exists" "\\nexists" "\\top" "\\bot"
    "\\angle" "\\triangle" "\\square" "\\prime" "\\surd" "\\flat" "\\natural" "\\sharp"
    "\\cdots" "\\ldots" "\\vdots" "\\ddots" "\\dots" "\\dagger" "\\ddagger"))

(inline_formula
  [
    "$"
    "\\("
    "\\)"
  ] @punctuation.math)
(displayed_equation
  [
    "$$"
    "\\["
    "\\]"
  ] @punctuation.math)

((math_environment
  (begin
    name: (curly_group_text
      (text) @punctuation.math)))
  (#set! "priority" 105))
((math_environment
  (end
    name: (curly_group_text
      (text) @punctuation.math)))
  (#set! "priority" 105))

(label_definition
  name: (curly_group_label
    (_) @markup.link.tex))
(label_reference
  names: (curly_group_label_list
    (_) @markup.link.tex))
(label_reference_range
  from: (curly_group_label
    (_) @markup.link.tex)
  to: (curly_group_label
    (_) @markup.link.tex))
(citation
  keys: (curly_group_text_list) @markup.link.tex)

((package_include
  paths: (curly_group_path_list) @variable.parameter)
  (#set! "priority" 105))
((class_include
  path: (curly_group_path) @variable.parameter)
  (#set! "priority" 105))
((latex_include
  path: (curly_group_path) @markup.link.path)
  (#set! "priority" 105))
((verbatim_include
  path: (curly_group_path) @markup.link.path)
  (#set! "priority" 105))
((import_include
  directory: (curly_group_path) @markup.link.path
  file: (curly_group_path) @markup.link.path)
  (#set! "priority" 105))
((graphics_include
  path: (curly_group_path) @markup.link.path)
  (#set! "priority" 105))
((svg_include
  path: (curly_group_path) @markup.link.path)
  (#set! "priority" 105))
((inkscape_include
  path: (curly_group_path) @markup.link.path)
  (#set! "priority" 105))
((bibtex_include
  paths: (curly_group_path_list) @markup.link.path)
  (#set! "priority" 105))
((biblatex_include
  glob: (curly_group_glob_pattern) @markup.link.path)
  (#set! "priority" 105))

((command_name) @punctuation.backslash
  (#first-char! @punctuation.backslash)
  (#set! "priority" 200))
((command_name) @punctuation.backslash
  (#eq? @punctuation.backslash "\\\\")
  (#set! "priority" 200))
((_
  command: _ @punctuation.backslash)
  (#first-char! @punctuation.backslash)
  (#set! "priority" 200))
((math_delimiter
  left_command: _ @punctuation.backslash)
  (#first-char! @punctuation.backslash)
  (#set! "priority" 200))
((math_delimiter
  right_command: _ @punctuation.backslash)
  (#first-char! @punctuation.backslash)
  (#set! "priority" 200))
