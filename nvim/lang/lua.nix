{
  lsp.servers.lua_ls = {
    enable = true;
    config = {
      cmd = [ "lua-language-server" ];
      filetypes = [ "lua" ];
      root_markers = [ ".luarc.json" ".luarc.jsonc" ".git" ];
      settings = {
        Lua = {
          runtime.version = "LuaJIT";
          diagnostics.globals = [ "vim" "make_statuscolumn" "make_foldtext" ];
          workspace = {
            library.__raw = "vim.api.nvim_get_runtime_file('', true)";
            checkThirdParty = false;
          };
          telemetry.enable = false;
        };
      };
    };
  };

  files."after/ftplugin/lua.lua".localOpts = {
    wrap = false;
    sidescrolloff = 12;
  };
}
