{
  imports = [ ./highlights.nix ];

  plugins.lualine = {
    enable = true;
    settings =
      let
        mode = { __unkeyed-1 = "mode"; fmt.__raw = "function(s) return (s:gsub('(%a)%a*', '%1')) end"; };
        filename = { __unkeyed-1 = "filename"; path = 1; };
        branch = { __unkeyed-1 = "branch"; icon.__raw = ''"\u{e725}"''; };
        location = { __unkeyed-1 = "location"; padding = 1; };
        recording = {
          __unkeyed-1.__raw = ''function() local r = vim.fn.reg_recording(); return r == "" and "" or ("recording @" .. r) end'';
          color = "StlRecording";
        };
        diagnostics = {
          __unkeyed-1 = "diagnostics";
          symbols = {
            error.__raw = ''"\u{F057}"'';
            warn.__raw = ''"\u{F071}"'';
            info.__raw = ''"\u{F05A}"'';
            hint.__raw = ''"\u{F05B}"'';
          };
          colored = false;
        };

      in
      {
        options = {
          icons_enabled = true;
          theme = {
            normal = {
              a = "StlModeNormal";
              b = "StlTabActive";
              c = "StatusLine";
            };
            insert = {
              a = "StlModeInsert";
              b = "StlTabActive";
              c = "StatusLine";
            };
            visual = {
              a = "StlModeVisual";
              b = "StlTabActive";
              c = "StatusLine";
            };
            replace = {
              a = "StlModeReplace";
              b = "StlTabActive";
              c = "StatusLine";
            };
            command = {
              a = "StlModeCommand";
              b = "StlTabActive";
              c = "StatusLine";
            };
            terminal = {
              a = "StlModeTerminal";
              b = "StlTabActive";
              c = "StatusLine";
            };
            inactive = {
              a = "StlTabInactive";
              b = "StlTabInactive";
              c = "StlTabInactive";
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
          always_divide_middle = true;
          globalstatus = false;
          refresh = {
            statusline = 1000;
            winbar = 1000;
            refresh_time = 16;
            events = [
              "WinEnter"
              "BufEnter"
              "BufWritePost"
              "SessionLoadPost"
              "FileChangedShellPost"
              "VimResized"
              "Filetype"
              "CursorMoved"
              "CursorMovedI"
              "ModeChanged"
              "RecordingEnter"
              "RecordingLeave"
            ];
          };
        };

        sections = {
          lualine_a = [ mode ];
          lualine_b = [ filename ];
          lualine_c = { __empty = null; };
          lualine_x = [ diagnostics recording branch "filetype" ];
          lualine_y = { __empty = null; };
          lualine_z = [ location ];
        };

        inactive_sections = {
          lualine_a = { __empty = null; };
          lualine_b = [ filename ];
          lualine_c = { __empty = null; };
          lualine_x = { __empty = null; };
          lualine_y = [ branch "filetype" ];
          lualine_z = [ location ];
        };
      };
  };

}
