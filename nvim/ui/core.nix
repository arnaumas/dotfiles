{
  opts = {
    number = false;
    relativenumber = true;
    numberwidth = 1;
    linebreak = true;
    breakindent = true;
    cursorline = true;
    cursorlineopt = "screenline";
    scrolloff = 20;
    splitbelow = true;
    splitright = true;
    smoothscroll = true;
    fillchars = {
      eob = " ";
    };
    cmdheight = 0;
    cmdwinheight = 10;
    showmode = false;
    showcmd = false;
    shortmess = "ltToOCFscS";
    termguicolors = false;
    guicursor = "n-v-c-sm:block,i-ci-ve-t:ver25,r-cr-o:hor20";
  };
  
  extraConfigLua = ''
    		pcall(function() require('vim._core.ui2').enable() end)
    	'';
}
