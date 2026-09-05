{
  plugins.lualine = {
    enable = true;
    settings =
      let
        mkFilename = color: {
          __unkeyed-1 = "filename";
          path = 1;
          color = color;
          symbols = {
            modified = "[+]";
            readonly = "[-]";
            unnamed = "[No Name]";
          };
        };
        branch = {
          __unkeyed-1 = "branch";
          icon.__raw = ''"\u{e725}"'';
        };
        location = {
          __unkeyed-1 = "location";
          padding = 1;
        };
        macro = {
          __unkeyed-1.__raw = ''function() local r = vim.fn.reg_recording(); return r == "" and "" or ("recording @" .. r) end'';
          color = "DiagnosticInfo";
        };
      in
      {
        options = {
          icons_enabled = true;
          # theme maps lualine sections to our custom Stl* highlight groups.
          theme = {
            normal = {
              a = "StlModeNormal";
              b = "StatusLine";
              c = "StatusLine";
            };
            insert = {
              a = "StlModeInsert";
              b = "StatusLine";
              c = "StatusLine";
            };
            visual = {
              a = "StlModeVisual";
              b = "StatusLine";
              c = "StatusLine";
            };
            replace = {
              a = "StlModeReplace";
              b = "StatusLine";
              c = "StatusLine";
            };
            command = {
              a = "StlModeCommand";
              b = "StatusLine";
              c = "StatusLine";
            };
            terminal = {
              a = "StlModeTerminal";
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
          disabled_filetypes = {
            statusline = [ ];
            winbar = [ ];
          };
          ignore_focus = [ "oil" "fzf" ];
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
          lualine_a = [
            {
              __unkeyed-1 = "mode";
              fmt.__raw = "function(s) return (s:gsub('(%a)%a*', '%1')) end";
            }
          ];
          lualine_b = {
            __empty = null;
          };
          lualine_c = [ (mkFilename "StlTabActive") ];
          lualine_x = {
            __empty = null;
          };
          lualine_y = [
            {
              __unkeyed-1 = "diagnostics";
              symbols = {
                error.__raw = ''"\u{f015a}%#StatusLine# "'';
                warn.__raw = ''"\u{f002a}%#StatusLine# "'';
                info.__raw = ''"\u{f02fd}%#StatusLine# "'';
                hint.__raw = ''"\u{f0336}%#StatusLine# "'';
              };
              diagnostics_color = {
                error = "StlDiagnosticError";
                warn = "StlDiagnosticWarn";
                info = "StlDiagnosticInfo";
                hint = "StlDiagnosticHint";
              };
            }
            macro
            branch
            "filetype"
          ];
          lualine_z = [ location ];
        };

        inactive_sections = {
          lualine_a = {
            __empty = null;
          };
          lualine_b = {
            __empty = null;
          };
          lualine_c = [ (mkFilename "StlTabInactive") ];
          lualine_x = {
            __empty = null;
          };
          lualine_y = [
            {
              __unkeyed-1 = "diagnostics";
              symbols = {
                error.__raw = ''"\u{f015a} %#StatusLineNC#"'';
                warn.__raw = ''"\u{f002a} %#StatusLineNC#"'';
                info.__raw = ''"\u{f02fd} %#StatusLineNC#"'';
                hint.__raw = ''"\u{f0336} %#StatusLineNC#"'';
              };
            }
            branch
            "filetype"
          ];
          lualine_z = [ location ];
        };

        extensions = [ ];
      };
  };

  colors.extraLua = builtins.readFile ./highlights.lua;
}
