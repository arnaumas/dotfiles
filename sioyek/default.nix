{ config, lib, pkgs, theme, ... }:
let
	opaque = c: "${c}ff";

	mkPalette = theme: {
		background_color                         = theme.termBg;
		custom_color_mode_empty_background_color = theme.termBg;
		page_separator_color                     = theme.termBg;
		text_highlight_color                     = theme.uiBg;
		visual_mark_color                        = opaque theme.uiBg;
		search_highlight_color                   = theme.yellow;
		link_highlight_color                     = theme.blue;
		synctex_highlight_color                  = theme.green;
		highlight_color_a                        = theme.yellow;
		highlight_color_b                        = theme.green;
		highlight_color_c                        = theme.cyan;
		highlight_color_d                        = theme.red;
		highlight_color_e                        = theme.magenta;
		highlight_color_f                        = theme.blue;
		highlight_color_g                        = theme.yellow;
		keyboard_select_background_color         = opaque theme.green;
		keyboard_select_text_color               = opaque theme.uiFg;
		custom_background_color                  = theme.termBg;
		custom_text_color                        = theme.uiFg;
		ui_text_color                            = theme.uiFg;
		ui_background_color                      = theme.uiDimBg;
		ui_selected_text_color                   = theme.uiFg;
		ui_selected_background_color             = theme.uiBg;
		status_bar_color                         = theme.uiDimBg;
		status_bar_text_color                    = theme.uiFg;
	};

	lightPalette = mkPalette theme.light // { custom_text_color = "#16191f"; };
	darkPalette = mkPalette theme.dark;

	toMacro = colors: lib.concatStringsSep ";"
		(lib.mapAttrsToList (k: v: "setconfig_${k}(${v})") (colors));
in {
	programs.sioyek = {
		enable = true;
		package = pkgs.sioyek.overrideAttrs (old: {
    postInstall = old.postInstall + ''
      res=$out/Applications/sioyek.app/Contents/Resources
      mkdir -p $res
      ln -s ../MacOS/shaders $res/shaders
      for c in prefs prefs_user keys keys_user; do
        ln -s ../MacOS/$c.config $res/$c.config
      done
      ln -s ../MacOS/tutorial.pdf $res/tutorial.pdf
    '';
		});

		bindings = {
			reload_config = "<C-r>";
			move_right = "l";
			move_left = "h";
			screen_down = "J";
			screen_up = "K";
			previous_page = "<C-u>";
			"[m]control_menu(up)"    = "<C-k>";
			"[m]control_menu(left)"  = "<C-h>";
			"[m]control_menu(right)" = "<C-l>";
			goto_prev_tab = "<C-p>";
			add_highlight    = "ah";
			delete_highlight = "xh";
			fit_to_page_width_smart = "s";
			fit_to_page_width       = "S";
			enter_visual_mark_mode = "v";
			keyboard_select        = "<C-v>";
			goto_mark = "^";
			_set_light_theme = "zl";
			_set_dark_theme  = "zd";
			toggle_two_page_mode     = "d";
			noop                     = "p";
			toggle_presentation_mode = "p";
			toggle_statusbar         = "zt";
		};

		config = {
			ui_font                   = "Geist Mono";
			font_size                 = "11";
			status_font               = "Geist Mono";
			status_bar_font_size      = "11";
			keyboard_select_font_size = "11";
			status_bar_format       = ". %{current_page_label} [%{current_page}/%{num_pages}]%{chapter_name}";
			right_status_bar_format = "%{search_results}%{search_progress} ";
			macos_hide_titlebar = "0";
			vertical_move_amount   = "1";
			horizontal_move_amount = "1";
			collapsed_toc                    = "1";
			page_labels_in_table_of_contents = "1";
			should_launch_new_window = "1";
			open_last_file_on_startup = "1";
			startup_commands = [ "toggle_custom_color" "toggle_statusbar" ];
			"new_macro _set_light_theme" = toMacro lightPalette;
			"new_macro _set_dark_theme" = toMacro darkPalette;
		} // darkPalette;
	};
}
