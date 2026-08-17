{ pkgs, ... }:
{
  # LSP via nixvim's native `lsp` module (matches your vim.lsp.enable + lsp/*.lua
  # approach). ported from lsp/lua_ls.lua, lsp/texlab.lua, plugin/21_lsp.lua.
  # servers were installed via Homebrew/Brewfile before; now via extraPackages.
  #
  # VERIFY (biggest unknown in the port): the exact shape of nixvim's native
  # `lsp` module. If `lsp.servers.<name>.config` is wrong, the fallback is to
  # carry lsp/*.lua verbatim via extraFiles + extraConfigLua "vim.lsp.enable{...}".
  extraPackages = with pkgs; [ texlab lua-language-server ];

  lsp = {
    servers = {
      lua_ls = {
        enable = true;
        config = {
          cmd = [ "lua-language-server" ];
          filetypes = [ "lua" ];
          root_markers = [ ".luarc.json" ".luarc.jsonc" ".git" ];
          settings = {
            Lua = {
              runtime.version = "LuaJIT";
              # only globals actually referenced by the config (pruned from the
              # original's stale MiniDeps/MiniPick/MiniExtra).
              diagnostics.globals = [ "vim" "MiniFiles" "FoldText" ];
              workspace = {
                library.__raw = "vim.api.nvim_get_runtime_file('', true)";
                checkThirdParty = false;
              };
              telemetry.enable = false;
            };
          };
        };
      };

      texlab = {
        enable = true;
        config = {
          cmd = [ "texlab" ];
          filetypes = [ "tex" "plaintex" "bib" ];
          root_markers = [ ".latexmkrc" ".git" ];
          settings = {
            texlab = {
              diagnostics.ignoredPatterns = [ "Command terminated with space" ];
              chktex = { onOpenAndSave = true; onEdit = false; };
              latexFormatter = "latexindent";
            };
          };
        };
      };
    };
  };

  # buffer-local maps shared by every server (from plugin/21_lsp.lua).
  autoGroups.lsp-attach = { clear = true; };
  autoCmd = [
    {
      event = [ "LspAttach" ];
      group = "lsp-attach";
      desc = "LSP buffer-local keymaps";
      callback.__raw = ''
        function(ev)
          local map = function(keys, fn, desc)
            vim.keymap.set('n', keys, fn, { buffer = ev.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
          map('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
          map('<Leader>d', vim.diagnostic.open_float, 'show [d]iagnostic')
        end
      '';
    }
  ];
}
