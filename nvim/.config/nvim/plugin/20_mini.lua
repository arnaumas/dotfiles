local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- statusline ->
later(function() 
	local statusline = require('mini.statusline')
	statusline.setup()
	statusline.section_location = function() return '%2l:%-2v' end
end)
-- <-

-- icons ->
later(function() require('mini.icons').setup() end)
-- <-

