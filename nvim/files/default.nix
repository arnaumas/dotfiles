{
  imports = [ ./highlights.nix ];


  plugins.nvim-tree = {
    enable = true;
    settings = {
      disable_netrw = true;
      hijack_netrw = true;
      hijack_directories.enable = true;
      filters = {
        dotfiles = false;
        custom = [ ".DS_Store" ];
      };
      view = {
        side = "left";
        width = 30;
      };
      renderer = {
        group_empty = true;
        highlight_opened_files = "name";
        root_folder_label = false;
        icons = {
          git_placement = "signcolumn";
          glyphs.git = {
            untracked = "○";
            unstaged = "◉";
            staged = "●";
            renamed = "➜";
            unmerged  = "";
            deleted = "";
            ignored = "◌";
          };
        };
      };
      on_attach.__raw = ''
      function(bufnr)
        local api = require('nvim-tree.api')
        api.config.mappings.default_on_attach(bufnr)
        local function o(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set('n', 'l', api.node.open.edit, o('open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, o('close directory'))
      end
      '';
    };
  };

  plugins.lualine.settings = {
    extensions = [ "nvim-tree" ];
    options.ignore_focus = [ "NvimTree" ];
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ef";
      action.__raw = "function() require('nvim-tree.api').tree.toggle({ find_file = true }) end";
      options.desc = "[e]xplore [f]ile directory";
    }
    {
      mode = "n";
      key = "<leader>ed";
      action.__raw = "function() require('nvim-tree.api').tree.open({ path = '/Users/arnau/home/dotfiles' }) end";
      options.desc = "[e]xplore [d]otfiles";
    }
    {
      mode = "n";
      key = "<leader>en";
      action.__raw = "function() require('nvim-tree.api').tree.open({ path = '/Users/arnau/home/dotfiles/nvim' }) end";
      options.desc = "[e]xplore [n]eovim config";
    }
    {
      mode = "n";
      key = "<leader>ez";
      action.__raw = "function() require('nvim-tree.api').tree.open({ path = '/Users/arnau/home/dotfiles/shell/zsh' }) end";
      options.desc = "[e]xplore [z]sh config";
    }
  ];

  extraConfigLua = ''
    do
      local api = require('nvim-tree.api')
      api.events.subscribe(api.events.Event.TreeRendered, function(data)
        if data.winnr and vim.api.nvim_win_is_valid(data.winnr) then
          vim.wo[data.winnr].statuscolumn = ""
        end
      end)
    end
  '';
}
