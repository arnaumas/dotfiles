{
  # ported from plugin/10_options.lua
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
    fillchars = { eob = " "; }; # no ~ past end of buffer
    signcolumn = "number"; # diagnostics in the number column
    cmdheight = 0;
    cmdwinheight = 1;
    showmode = false;
    showcmd = false;
    shortmess = "ltToOCFscS";

    # editing (hard tabs, shiftwidth 2)
    expandtab = false;
    shiftwidth = 2;
    tabstop = 2;

    # colorscheme is terminal-anchored: cterm indices map to the 16 ANSI slots.
    # termguicolors OFF on purpose. colorscheme itself is set in colorscheme.nix.
    termguicolors = false;
  };

  globals = {
    mapleader = " ";
    maplocalleader = " "; # same as leader, matching the current config
    have_nerd_font = true;
  };

  # experimental internal UI. VERIFY: vim._core.ui2 may not exist on the nvim
  # that nixpkgs/nixvim pins; guarded so a missing module does not abort startup.
  extraConfigLua = ''
    pcall(function() require('vim._core.ui2').enable() end)
  '';
}
