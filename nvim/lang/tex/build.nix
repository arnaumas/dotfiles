{
  plugins.vimtex = {
    enable = true;
    settings = {
      view_method = "sioyek";
      quickfix_open_on_warning = 0;
      log_ignore = [
        "Compilation completed"
        "Compilation failed"
        "Compiler start"
        "Compiler stopped"
      ];
    };
  };

  autoCmd = [
    {
      event = "User";
      pattern = "VimtexEventCompileStarted";
      callback.__raw = "function() vim.notify('VimTeX: compiling ' .. vim.b.vimtex.base, vim.log.levels.INFO) end";
    }
    {
      event = "User";
      pattern = "VimtexEventCompileSuccess";
      callback.__raw = "function() vim.notify('VimTeX: compiled ' .. vim.b.vimtex.base, vim.log.levels.INFO) end";
    }
    {
      event = "User";
      pattern = "VimtexEventCompileStopped";
      callback.__raw = "function() vim.notify('VimTeX: compiler stopped', vim.log.levels.INFO) end";
    }
    {
      event = "User";
      pattern = "VimtexEventCompileFailed";
      callback.__raw = "function() vim.notify(('VimTeX: failed (%d qf entries)'):format(#vim.fn.getqflist()), vim.log.levels.ERROR) end";
    }
  ];
}
