{
	keymaps = [
		# general
		{ mode = "n"; key = "<esc>"; action = "<cmd>nohlsearch<cr>"; options.desc = "clear highlights"; }
		{ mode = [ "n" "x" ]; key = "<leader>r"; action = "q"; options.desc = "[r]ecord macro"; }
		{ mode = [ "n" "x" ]; key = "q"; action = "<nop>"; }
		{ mode = "n"; key = ":"; action = "q:i"; }

		# editing
		{ mode = "n"; key = "o"; action = "o<esc>"; options.desc = "[o]pen line"; }
		{ mode = "n"; key = "O"; action = "O<esc>"; options.desc = "[o]pen line above"; }
		{ mode = [ "n" "x" ]; key = "u"; action.__raw = "function() vim.cmd[[ silent undo ]] end"; }
		{ mode = [ "n" "x" ]; key = "K"; action = "i<cr><esc>"; }

		# window moving / resizing
		{ mode = "n"; key = "<leader>h"; action = "<C-w><C-h>"; options.desc = "focus window left"; }
		{ mode = "n"; key = "<leader>l"; action = "<C-w><C-l>"; options.desc = "focus window right"; }
		{ mode = "n"; key = "<leader>j"; action = "<C-w><C-j>"; options.desc = "focus window below"; }
		{ mode = "n"; key = "<leader>k"; action = "<C-w><C-k>"; options.desc = "focus window above"; }
		{ mode = "n"; key = "<leader>+"; action.__raw = "function() vim.cmd.resize('+5') end"; }
		{ mode = "n"; key = "<leader>-"; action.__raw = "function() vim.cmd.resize('-5') end"; }

		# buffer
		{ mode = "n"; key = "<leader>w"; action.__raw = "function() vim.cmd[[ silent update ]] end"; options.desc = "[w]rite file"; }
		{ mode = "n"; key = "<leader>q"; action = "<cmd>quitall<CR>"; options.desc = "[q]uit file"; }
		{ mode = "n"; key = "<leader>Q"; action.__raw = "function() vim.cmd.quit({ bang = true }) end"; options.desc = "force [q]uit file"; }
		{ mode = "n"; key = "<leader>bn"; action.__raw = "vim.cmd.bn"; options.desc = "[b]uffer [n]ext"; }
		{ mode = "n"; key = "<leader>bp"; action.__raw = "vim.cmd.bp"; options.desc = "[b]uffer [p]revious"; }
		{ mode = "n"; key = "<leader>bd"; action.__raw = "vim.cmd.bd"; options.desc = "[b]uffer [d]elete"; }
		{ mode = "n"; key = "<leader>bs"; action.__raw = "vim.cmd.sp"; options.desc = "[b]uffer [s]plit"; }

		# source config (was Ls / Lc)
		{
			mode = "n";
			key = "<leader>Ls";
			action.__raw = "function() vim.cmd.source('%') vim.notify('Sourced file') end";
			options.desc = "[L]ua [s]ource file";
		}
		{
			mode = "n";
			key = "<leader>Lc";
			action.__raw = ''
				function()
					for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath('config'), '**/*.lua', false, true)) do
						vim.cmd.source(f)
					end
					vim.notify('Sourced ~/.config/nvim')
				end
			'';
			options.desc = "[L]ua source [c]onfig";
		}
	];
}
