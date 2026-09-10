{
  imports = [ ../core ../ui/core.nix ];

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
    settings = 
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
      in {
        options = {
          icons_enabled = false;
          globalstatus = false;
          theme = {
            normal = {
              a = "UiSelected";
              b = "UiSelected";
              c = "UiSelected";
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
          lualine_a = [ filename ];
          lualine_b = { __empty = null; };
          lualine_c = { __empty = null; };
          lualine_x = { __empty = null; };
          lualine_y = { __empty = null; };
          lualine_z = [ location ];
        };
        inactive_sections = {
          lualine_a = [ filename ];
          lualine_b = { __empty = null; };
          lualine_c = { __empty = null; };
          lualine_x = { __empty = null; };
          lualine_y = { __empty = null; };
          lualine_z = [ location ];
        };
      };
  };
}
