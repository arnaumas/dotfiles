{
	# statusline + tabline. ported from plugin/20_plugins.lua lualine block.
	# `options` (incl. the custom Stl* theme) is typed; `sections` is carried
	# verbatim as __raw because it uses nerd-font \u{...} escapes and a fmt fn
	# that are error-prone to re-encode as Nix.
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

			sections.__raw = ''
				{
					lualine_a = {
						{ 'mode', fmt = function(s) return (s:gsub('(%a)%a*', '%1')) end }
					},
					lualine_b = {},
					lualine_c = {
						{
							'buffers',
							mode = 0,
							buffers_color = {
								active	 = 'StlTabActive',
								inactive = 'StlTabInactive',
							},
							symbols = {
								modified = ' [+]',
								alternate_file = '',
								directory = '/',
							}
						}
					},
					lualine_x = {},
					lualine_y = {
						{
							'diagnostics',
							symbols = {
								error = '\u{f015a} %#StatusLine#', warn = '\u{f002a} %#StatusLine#',
								info	= '\u{f02fd} %#StatusLine#', hint = '\u{f0336} %#StatusLine#',
							},
							diagnostics_color = {
								error = 'DiagnosticError', warn = 'DiagnosticWarn',
								info	= 'DiagnosticInfo',	 hint = 'DiagnosticHint',
							}
						},
						{ 'branch', icon = '\u{e725}' },
						'filetype'
					},
					lualine_z = {'location'}
				}
			'';

			extensions = [ ];
		};
	};
}
