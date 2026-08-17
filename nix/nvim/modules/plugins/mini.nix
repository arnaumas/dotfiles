{
  # mini.nvim: ai, surround, files, git, icons, notify. eager (it is the UI).
  # ported from plugin/20_plugins.lua mini blocks.
  plugins.mini = {
    enable = true;
    mockDevIcons = true; # icons.mock_nvim_web_devicons() -> route lualine icons here

    modules = {
      ai = { };
      surround = { silent = true; };

      files = {
        options = { use_as_default_explorer = true; };
        content = {
          filter.__raw = "function(fs_entry) return fs_entry.name ~= '.DS_Store' end";
        };
      };

      git = { };

      icons = {
        default = { file = { glyph = "󰈔"; }; };
        file = {
          "init.lua" = { glyph = "󰢱"; hl = "MiniIconsAzure"; };
        };
        extension = { toml = { glyph = "󰈔"; }; };
      };

      notify = {
        window = {
          config.__raw = ''
            function()
              local has_statusline = vim.o.laststatus > 0
              local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
              return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
            end
          '';
          winblend = 0;
        };
        # lualine owns the LSP loading indicator; mini.notify stays the vim.notify backend.
        lsp_progress = { enable = false; };
      };
    };
  };

  # route vim.notify through mini.notify (nixvim's mini module does not do this).
  # VERIFY: ordering after mini setup.
  extraConfigLua = ''
    vim.notify = require('mini.notify').make_notify()
  '';

  keymaps = [
    # explore (mini.files)
    { mode = "n"; key = "<leader>ef"; action.__raw = "function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end"; options.desc = "[e]xplore [f]ile directory"; }
    { mode = "n"; key = "<leader>ed"; action.__raw = "function() MiniFiles.open('/Users/arnau/dotfiles', false) end"; options.desc = "[e]xplore [d]otfiles"; }
    { mode = "n"; key = "<leader>en"; action.__raw = "function() MiniFiles.open('/Users/arnau/dotfiles/nvim/.config/nvim', false) end"; options.desc = "[e]xplore [n]eovim config"; }
    { mode = "n"; key = "<leader>ez"; action.__raw = "function() MiniFiles.open('/Users/arnau/dotfiles/zsh/.config/zsh', false) end"; options.desc = "[e]xplore [z]sh config"; }

    # git (mini.git provides :Git)
    { mode = "n"; key = "<leader>gc"; action = "<cmd>Git commit<cr>"; options.desc = "[g]it [c]ommit"; }
    { mode = "n"; key = "<leader>ga"; action = "<cmd>Git diff --cached<cr>"; options.desc = "[g]it [a]dd"; }
  ];
}
