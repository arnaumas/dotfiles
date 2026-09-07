{
  imports = [ ./highlights.nix ];

  plugins.fzf-lua = {
    enable = true;
    profile.__raw = "false";
    settings = {
      winopts = {
        title = "";
        title_flags = false;
        border = [
          ""
          ""
          ""
          " "
          ""
          ""
          ""
          " "
        ];
        preview = {
          border = [
            " "
            "─"
            " "
            " "
            ""
            ""
            ""
            " "
          ];
          title = false;
          scrollbar = false;
        };
      };

      fzf_colors.__raw = ''
        {
          true,
          ["hl"]       = { "fg", "FzfLuaFzfMatch", "bold" },
          ["hl+"]      = { "fg", "FzfLuaFzfMatch", "bold" },
          ["bg+"]      = { "bg", "UiSelected" },
          ["fg+"]      = { "fg", "UiSelected", "bold" },
          ["marker"]   = { "fg", "FzfLuaFzfMatch", "bold" },
          ["prompt"] = { "fg", "FzfLuaFzfPrompt", "regular" },
        }
      '';
      fzf_opts = {
        "--layout" = "reverse";

        "--no-scrollbar" = true;
        "--no-separator" = true;
        "--info" = "hidden";

        "--pointer" = " ";
        "--marker" = ">";

        "--cycle" = true;
      };

      keymap.builtin."<C-o>" = "toggle-preview";

      # pickers
      hls = {
        normal = "FzfLuaNormal";
        border = "FzfLuaNormal";
        preview_normal = "FzfLuaNormal";
        preview_border = "FzfLuaPreviewBorder";
      };

      defaults = {
        color_icons = false;
      };

      files = {
        prompt = "files > ";
      };

      grep = {
        prompt = "grep > ";
      };

      helptags = {
        prompt = "help > ";
      };

      highlights = {
        prompt = "highlights > ";
      };

      buffers = {
        prompt = "buffers > ";
        headers = false;
        winopts = {
          row = 1;
          col = 3;
          width = 0.3;
          preview = {
            hidden = true;
          };
        };
        fzf_opts = {
          "--layout" = "default";
        };
      };

      blines = {
        prompt = "buffer > ";
        winopts = {
          preview = {
            hidden = true;
          };
        };
      };

      lines = {
        prompt = "all buffers > ";
        winopts = {
          preview = {
            hidden = true;
          };
        };
      };
    };
  };

  extraConfigLua = ''
    		require('fzf-lua').register_ui_select(nil, true)
    	'';

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action.__raw = "require('fzf-lua').files";
      options.desc = "[f]ind in [f]iles";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action.__raw = ''
        function()
          local n = #vim.fn.getbufinfo({ buflisted = 1 })
          require('fzf-lua').buffers({ winopts = { height = n + 1 } })
        end
      '';
      options.desc = "[f]ind in open [b]uffers";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action.__raw = "require('fzf-lua').live_grep";
      options.desc = "[f]ind in [g]rep";
    }
    {
      mode = "n";
      key = "<leader>fh";
      action.__raw = "require('fzf-lua').help_tags";
      options.desc = "[f]ind in [h]elp";
    }
    {
      mode = "n";
      key = "<leader>fH";
      action.__raw = "require('fzf-lua').highlights";
      options.desc = "[f]ind in [H]ighlight groups";
    }
    {
      mode = "n";
      key = "<leader>fl";
      action.__raw = "require('fzf-lua').blines";
      options.desc = "[f]ind in buffer [l]ines";
    }
    {
      mode = "n";
      key = "<leader>fL";
      action.__raw = "require('fzf-lua').lines";
      options.desc = "[f]ind in all buffer [l]ines";
    }
  ];

  plugins.lualine.settings = {
    extensions = [ "fzf" ];
    ignore_focus = [ "fzf" ];
  };
}
