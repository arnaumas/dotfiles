{
  # snippets. ported from plugin/20_plugins.lua LuaSnip block + the snippet
  # jump keymaps in plugin/11_keymaps.lua. snippet definitions stay as a real
  # Lua file (snippets/tex.lua), loaded from the nix-store copy.
  plugins.luasnip = {
    enable = true;
    # VERIFY: fromLua option name + that `paths` accepts a nix path.
    fromLua = [ { paths = ../../snippets; } ];
    settings = {
      cut_selection_keys = [ "<C-l>" "<tab>" ];
      enable_autosnippets = true;
      update_events = "TextChanged, TextChangedI";
    };
  };

  keymaps = [
    {
      mode = [ "i" "s" ];
      key = "<C-l>";
      options.silent = true;
      action.__raw = ''
        function()
          local luasnip = require('luasnip')
          if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
        end
      '';
    }
    {
      mode = [ "i" "s" ];
      key = "<C-h>";
      options.silent = true;
      action.__raw = ''
        function()
          local luasnip = require('luasnip')
          if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
        end
      '';
    }
    {
      mode = [ "i" "s" ];
      key = "<tab>";
      options.silent = true;
      action.__raw = ''
        function()
          local luasnip = require('luasnip')
          if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
        end
      '';
    }
  ];
}
