{
  imports = [ ./imaps.nix ];

  plugins.vimtex.settings = {
    syntax_enabled = 0;
    fold_enabled = 0;
    indent_on_ampersands = 1;
    indent_tikz_commands = 0;
  };

  files."after/ftplugin/tex.lua" = {
    localOpts = {
      cursorlineopt = "screenline";
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      indentexpr = "v:lua.tex_indent()";
    };
    keymaps = [
      {
        mode = "n";
        key = "o";
        action = "g$a<cr><esc>";
      }
      # { mode = [ "n" "o" "v" ]; key = "j"; action = "gj"; options = { silent = true; buffer = true; }; }
      # { mode = [ "n" "o" "v" ]; key = "k"; action = "gk"; options = { silent = true; buffer = true; }; }
      # { mode = [ "n" "o" "v" ]; key = "0"; action = "g0"; options = { silent = true; buffer = true; }; }
      # { mode = [ "n" "o" "v" ]; key = "$"; action = "g$"; options = { silent = true; buffer = true; }; }
      # { mode = "o"; key = "_"; action = "g_"; options = { silent = true; buffer = true; }; }
    ];
    extraConfigLua = ''
      if not vim.g.tex_mathzone_override then
      	vim.cmd([[
      		silent! call vimtex#syntax#in_mathzone()
      		function! vimtex#syntax#in_mathzone(...) abort
      			return luaeval('_G.tex_in_math()')
      		endfunction
      	]])
      	vim.g.tex_mathzone_override = 1
      end
    '';
  };

  extraConfigLua =
    builtins.readFile ./setup.lua
    + "\n"
    + builtins.readFile ./folds.lua
    + "\n"
    + ''
      vim.treesitter.query.set('latex', 'folds', [==[
    ''
    + builtins.readFile ./folds.scm
    + ''
      ]==])
    '';
}
