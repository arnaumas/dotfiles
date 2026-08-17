{
	opts = {
		# general
		swapfile = false;
		# was set inside vim.schedule() as a startup nicety; plain opt is equivalent.
		clipboard = "unnamedplus";

		# ui
		number = true;
		relativenumber = true;
		linebreak = true; # wrap at word boundaries
		breakindent = true; # keep indent on wrapped lines
		cursorline = true;
		scrolloff = 20;
		splitbelow = true;
		splitright = true;
		smoothscroll = true;
    fillchars = { eob = " "; fold = " "; };
    signcolumn = "no";
    foldcolumn = "0";
    statuscolumn = "%{%v:lua.StatusColumn()%}";
		cmdheight = 0;
		cmdwinheight = 10;
		showmode = false;
		showcmd = false;
		shortmess = "ltToOCFscS";

		# editing
		expandtab = false;
		shiftwidth = 2;
		tabstop = 2;

		termguicolors = false;
	};

	globals = {
		mapleader = " ";
		maplocalleader = " "; # same as leader, matching the current config
		have_nerd_font = true;
	};

	extraConfigLua = ''
	local function hl_at(info)
		local ts = info.treesitter
		if ts then
			for i = #ts, 1, -1 do
				local cap = ts[i].capture
				if cap ~= 'spell' and cap ~= 'nospell' and cap ~= 'conceal' then
					return ts[i].hl_group
				end
			end
		end
		local syn = info.syntax
		if syn and #syn > 0 then return syn[#syn].hl_group end
		return 'Normal'
	end

	local function line_chunks(lnum)
		local buf = vim.api.nvim_get_current_buf()
		local line = vim.fn.getline(lnum)
		if line == ''' then return {} end
		local row = lnum - 1
		local chunks, cur, start = {}, nil, 0
		for col = 0, #line - 1 do
			local info = vim.inspect_pos(buf, row, col,
				{ syntax = true, treesitter = true, extmarks = false, semantic_tokens = false })
			local hl = hl_at(info)
			if hl ~= cur then
				if cur then chunks[#chunks + 1] = { line:sub(start + 1, col), cur } end
				cur, start = hl, col
			end
		end
		chunks[#chunks + 1] = { line:sub(start + 1), cur or 'Normal' }
		return chunks
	end

	FoldText = function()
		local chunks = line_chunks(vim.v.foldstart)
		chunks[#chunks + 1] = { '•••', 'FoldEllipsis' }
		return chunks
	end

	vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
		callback = function() vim.wo.foldtext = 'v:lua.FoldText()' end,
	})

	local function fold_mark(lnum)
		if vim.fn.foldlevel(lnum) == 0 then return ' ' end
		if vim.fn.foldclosed(lnum) ~= -1 then return '%#FoldColumn#\u{F460}' end
		if lnum == 1 or vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
			return '%#FoldColumn#\u{F47C}'
		end
		return '%#FoldColumn#\u{23B9}'
	end

	local function sign(lnum)
		local best
		local marks = vim.api.nvim_buf_get_extmarks(0, -1, { lnum - 1, 0 }, { lnum - 1, -1 },
			{ details = true, type = 'sign' })
		for _, mark in ipairs(marks) do
			local d = mark[4]
			if d.sign_text and (not best or (d.priority or 0) > (best.priority or 0)) then best = d end
		end
		if best then return best.sign_text, best.sign_hl_group or 'SignColumn' end
	end

	local function number(hl, n, cells)
		return ('%%#' .. hl .. '#%' .. cells .. 'd'):format(n)
	end

	StatusColumn = function()
		local lnum = vim.v.lnum
		local width = #tostring(vim.api.nvim_buf_line_count(0))
		if vim.v.virtnum > 0 then
			local mark = vim.fn.foldlevel(lnum) > 0 and '%#FoldColumn#\u{23B9}' or ' '
			return string.rep(' ', width) .. mark .. ' '
		end
		if vim.v.virtnum < 0 then return ''' end
		local text, hl = sign(lnum)
		if text then
			text = text:gsub('%s+$', ''')
			local pad = width - vim.fn.strdisplaywidth(text)
			return ('%s%%#%s#%s%s '):format(pad > 0 and string.rep(' ', pad) or ''', hl, text, fold_mark(lnum))
		end
		local cursor = vim.v.relnum == 0
		local n = cursor and lnum or vim.v.relnum
		return number(cursor and 'CursorLineNr' or 'LineNr', n, width) .. fold_mark(lnum) .. ' '
	end

	pcall(function() require('vim._core.ui2').enable() end)
	'';
}
