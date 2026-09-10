{
  files."after/ftplugin/help.lua".keymaps = [
    {
      mode = "n";
      key = "q";
      action = "<cmd>helpclose<cr>";
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
  
  plugins.lualine.settings.extensions = 
    let 
      filename = {
        __unkeyed-1 = "filename";
        path = 0;
        file_status = false;
      };
      location = {
      __unkeyed-1 = "location";
      padding = 1;
      };
    in [ 
      {
        filetypes = [ "help" ];
        sections = {
          lualine_a = { __empty = null; };
          lualine_b = [ filename ];
          lualine_c = { __empty = null; };
          lualine_x = { __empty = null; };
          lualine_y = [ location ];
          lualine_z = { __empty = null; };
        };
        inactive_sections = {
          lualine_a = { __empty = null; };
          lualine_c = [ filename ];
          lualine_b = { __empty = null; };
          lualine_x = { __empty = null; };
          lualine_y = [ location ];
          lualine_z = { __empty = null; };
        };
      }
    ];
}
