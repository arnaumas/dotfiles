return {
  require("luasnip").snippet(
  { trig = "hi" },
  { t("Hello, world!") }
  ),

  require("luasnip").snippet(
  { trig = "foo" },
  { t("Another snippet.") }
  ),

  require("luasnip").snippet(
  { trig = "test" },
  { t("a "), i(1), t(" a")}
  )
}
