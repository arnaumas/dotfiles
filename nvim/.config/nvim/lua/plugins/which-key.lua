return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    delay = 500, -- delay before opening which-key
    mappings = vim.g.have_nerd_font, -- enable icon mappings whenever a nerd font is installed
  }
}
