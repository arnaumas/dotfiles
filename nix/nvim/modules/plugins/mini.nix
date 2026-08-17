{
  # mini.nvim: ai, surround, files, git, icons, notify. eager (it is the UI).
  # ported from plugin/20_plugins.lua mini blocks.
  plugins.mini = {
    enable = true;
    mockDevIcons = true; # icons.mock_nvim_web_devicons() -> route lualine icons here

    modules = {
      ai = { };
      surround = { silent = true; };

      git = { };

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
    # git (mini.git provides :Git)
    { mode = "n"; key = "<leader>gc"; action = "<cmd>Git commit<cr>"; options.desc = "[g]it [c]ommit"; }
    { mode = "n"; key = "<leader>ga"; action = "<cmd>Git diff --cached<cr>"; options.desc = "[g]it [a]dd"; }
  ];
}
