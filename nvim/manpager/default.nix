{
  imports = [ ../core ];

  opts = {
    termguicolors = false;
    number = false;
    relativenumber = true;
    numberwidth = 1;
    cursorline = true;
    scrolloff = 20;
    linebreak = true;
    breakindent = true;
    showmode = false;
    laststatus = 2;
    cmdheight = 0;
    ruler = false;
    shortmess = "sS";
    fillchars = {
      eob = " ";
    };
  };

  autoGroups.highlight-yank = {
    clear = true;
  };

  autoCmd = [
    {
      event = [ "TextYankPost" ];
      group = "highlight-yank";
      desc = "Highlight when yanking (copying) text";
      callback.__raw = "function() vim.highlight.on_yank() end";
    }
  ];

  # man ergonomics, buffer-local so they win over core's global maps.
  files."after/ftplugin/man.lua".keymaps = [
    {
      mode = "n";
      key = "q";
      action = "<cmd>quit<cr>";
      options = {
        buffer = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<cr>";
      action = "<C-]>";
      options.buffer = true;
    }
    {
      mode = "n";
      key = "<bs>";
      action = "<C-t>";
      options.buffer = true;
    }
  ];

  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        icons_enabled = false;
        globalstatus = false;
        theme = {
          normal = {
            a = "StatusLine";
            b = "StatusLine";
            c = "StatusLine";
          };
          inactive = {
            a = "StatusLineNC";
            b = "StatusLineNC";
            c = "StatusLineNC";
          };
        };
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
      };
      sections = {
        lualine_a = {
          __empty = null;
        };
        lualine_b = {
          __empty = null;
        };
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            path = 0;
            color = "UiSelected";
            symbols = {
              modified = "";
              readonly = "";
              unnamed = "[No Name]";
              newfile = "";
            };
          }
        ];
        lualine_x = {
          __empty = null;
        };
        lualine_y = {
          __empty = null;
        };
        lualine_z = [
          {
            __unkeyed-1 = "location";
            padding = 1;
            color = "UiSelected";
          }
        ];
      };
    };
  };
}
