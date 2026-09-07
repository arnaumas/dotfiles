{
  plugins.luasnip = {
    enable = true;
    settings = {
      cut_selection_keys = "<Tab>";
      enable_autosnippets = true;
      update_events = "TextChanged, TextChangedI";
    };
  };

  keymaps = [
    {
      mode = [ "i" "s" ];
      key = "<Tab>";
      options.silent = true;
      action.__raw = ''
        function()
        	local luasnip = require('luasnip')
        	if luasnip.expand_or_locally_jumpable() then
        		luasnip.expand_or_jump()
        	else
        		local tab = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
        		vim.api.nvim_feedkeys(tab, 'n', false)
        	end
        end
      '';
    }
    {
      mode = [ "i" "s" ];
      key = "<S-Tab>";
      options.silent = true;
      action.__raw = ''
        function()
        	local luasnip = require('luasnip')
        	if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
        end
      '';
    }
  ];
}
