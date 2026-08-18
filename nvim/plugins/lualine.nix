{
	plugins.lualine = {
		enable = true;
		settings = {
			options = {
				icons_enabled = true;
				# theme maps lualine sections to our custom Stl* highlight groups.
				theme = {
					normal = { a = "StlModeNormal"; b = "StatusLine"; c = "StatusLine"; };
					insert = { a = "StlModeInsert"; b = "StatusLine"; c = "StatusLine"; };
					visual = { a = "StlModeVisual"; b = "StatusLine"; c = "StatusLine"; };
					replace = { a = "StlModeReplace"; b = "StatusLine"; c = "StatusLine"; };
					command = { a = "StlModeCommand"; b = "StatusLine"; c = "StatusLine"; };
					terminal = { a = "StlModeTerminal"; b = "StatusLine"; c = "StatusLine"; };
					inactive = { a = "StatusLineNC"; b = "StatusLineNC"; c = "StatusLineNC"; };
				};
				component_separators = { left = ""; right = ""; };
				section_separators = { left = ""; right = ""; };
				disabled_filetypes = { statusline = [ ]; winbar = [ ]; };
				ignore_focus = [ ];
				always_divide_middle = true;
				always_show_tabline = true;
				globalstatus = true;
				refresh = {
					statusline = 1000;
					buffers = 1000;
					winbar = 1000;
					refresh_time = 16;
					events = [
						"WinEnter" "BufEnter" "BufWritePost" "SessionLoadPost"
						"FileChangedShellPost" "VimResized" "Filetype"
						"CursorMoved" "CursorMovedI" "ModeChanged"
					];
				};
			};

			sections = {
				lualine_a = [
					{ __unkeyed-1 = "mode"; fmt.__raw = "function(s) return (s:gsub('(%a)%a*', '%1')) end"; }
				];
				lualine_b = { __empty = null; };
				lualine_c = [
					{
						__unkeyed-1 = "buffers";
						mode = 0;
						buffers_color = { active = "StlTabActive"; inactive = "StlTabInactive"; };
						symbols = { modified = " [+]"; alternate_file = ""; directory = "/"; };
					}
				];
				lualine_x = { __empty = null; };
				lualine_y = [
					{
						__unkeyed-1 = "diagnostics";
						symbols = {
							error.__raw = ''"\u{f015a} %#StatusLine#"'';
							warn.__raw  = ''"\u{f002a} %#StatusLine#"'';
							info.__raw  = ''"\u{f02fd} %#StatusLine#"'';
							hint.__raw  = ''"\u{f0336} %#StatusLine#"'';
						};
						diagnostics_color = {
							error = "DiagnosticError"; warn = "DiagnosticWarn";
							info  = "DiagnosticInfo";  hint = "DiagnosticHint";
						};
					}
					{ __unkeyed-1 = "branch"; icon.__raw = ''"\u{e725}"''; }
					"filetype"
				];
				lualine_z = [ "location" ];
			};

			extensions = [ ];
		};
	};
}
