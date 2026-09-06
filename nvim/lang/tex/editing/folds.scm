([
  (part)
  (chapter)
  (section)
  (subsection)
  (subsubsection)
  (paragraph)
  (subparagraph)
] @fold
  (#trim-blank! @fold))

[
  (math_environment)
  (displayed_equation)
] @fold

; do not fold document
((generic_environment
  (begin
    name: (curly_group_text
      (text) @_name)))
  @fold
  (#not-eq? @_name "document"))

; prelude fold
((generic_environment
  (begin
    name: (curly_group_text
      (text) @_name)))
  @fold
  (#eq? @_name "document")
  (#prelude! @fold))
