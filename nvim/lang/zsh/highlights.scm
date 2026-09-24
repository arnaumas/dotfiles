; extends

(variable_assignment
  (word) @none)

(concatenation
  (word) @none)

(command
  argument: [
    (word) @string.special.path
    (concatenation
      (word) @string.special.path)
  ]
  (#lua-match? @string.special.path "/"))

(command
  argument: [
    (word) @string.special.path
    (concatenation
      (word) @string.special.path)
  ]
  (#lua-match? @string.special.path "^~"))

((command_name
  (word) @none)
  (#not-command? @none))
