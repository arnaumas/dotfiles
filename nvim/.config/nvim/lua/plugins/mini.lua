return { 
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 } -- around/inside

      require('mini.surround').setup() -- surround

      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
	}
