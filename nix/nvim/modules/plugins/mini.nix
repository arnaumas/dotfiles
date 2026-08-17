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
		local notify = require('mini.notify')
		local win_config = function()
			local has_statusline = vim.o.laststatus > 0
			local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
			return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad, border = 'none' }
		end

		-- '● │ msg' in the popup, '● │ HH:MM:SS │ msg' in history. The dot is
		-- colored per level via a higher-priority ephemeral extmark (mini colors
		-- whole lines only).
		local dot, dot_ns = '●', vim.api.nvim_create_namespace('mini-notify-dot')
		local dot_hl = { ERROR = 'DiagnosticError', WARN = 'DiagnosticWarn', INFO = 'DiagnosticInfo',
			DEBUG = 'DiagnosticHint', TRACE = 'DiagnosticOk', OFF = 'MiniNotifyNormal' }
		local line_hl, in_history = {}, false
		local format = function(notif)
			local msg = notif.msg
			if in_history then
				msg = vim.fn.strftime('%H:%M:%S', math.floor(notif.ts_update)) .. ' ' .. msg
			end
			local res = ' ' .. dot .. ' ' .. msg
			line_hl[vim.split(res, '\n')[1]] = dot_hl[notif.level] or dot_hl.INFO
			return res
		end
		vim.api.nvim_set_decoration_provider(dot_ns, {
			on_win = function(_, _, buf) return vim.bo[buf].filetype:find('^mininotify') ~= nil end,
			on_line = function(_, _, buf, row)
				local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
				local hl = line ~= nil and line_hl[line] or nil
				if hl == nil then return end
				vim.api.nvim_buf_set_extmark(buf, dot_ns, row, 1,
					{ end_col = 1 + #dot, hl_group = hl, priority = 5000, ephemeral = true })
			end,
		})

		notify.setup({
			content = { format = format },
			window = { config = win_config, winblend = 0 },
			lsp_progress = { enable = true },
		})
		local plain = { hl_group = 'MiniNotifyNormal' }
		vim.notify = notify.make_notify({
			ERROR = plain, WARN = plain, INFO = plain, DEBUG = plain, TRACE = plain, OFF = plain,
		})
		vim.api.nvim_create_user_command('Notifications', function()
			in_history = true
			notify.show_history()
			in_history = false
		end, { desc = 'mini.notify history' })
	'';

	keymaps = [
		# git (mini.git provides :Git)
		{ mode = "n"; key = "<leader>gc"; action = "<cmd>Git commit<cr>"; options.desc = "[g]it [c]ommit"; }
		{ mode = "n"; key = "<leader>ga"; action = "<cmd>Git diff --cached<cr>"; options.desc = "[g]it [a]dd"; }
	];
}
