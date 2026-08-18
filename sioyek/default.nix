{ config, lib, ... }:
let
	cfgDir = "${config.xdg.configHome}/sioyek";
in
{
	programs.sioyek = {
		enable = true;

		bindings = {
			reload_config = "<C-r>";

			move_right = "l";
			move_left = "h";
			screen_down = "J";
			screen_up = "K";

			next_page = "<C-d>";
			previous_page = "<C-u>";

			"[m]control_menu(down)"  = "<C-j>";
			"[m]control_menu(up)"    = "<C-k>";
			"[m]control_menu(left)"  = "<C-h>";
			"[m]control_menu(right)" = "<C-l>";

			goto_next_tab = "<C-n>";
			goto_prev_tab = "<C-p>";

			close_window = "q";

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
			# light theme (inlined; the future color module will own these)
			background_color                         = "#faf9f7";
			custom_color_mode_empty_background_color = "#faf9f7";
			text_highlight_color                     = "#aaa9a4";
			visual_mark_color                        = "#aaa9a4";
			search_highlight_color                   = "#be7e05";
			link_highlight_color                     = "#5079be";
			synctex_highlight_color                  = "#608e32";
			highlight_color_a                        = "#be7e05";
			highlight_color_b                        = "#608e32";
			highlight_color_c                        = "#3a8b84";
			highlight_color_d                        = "#d05858";
			highlight_color_e                        = "#b05ccc";
			highlight_color_f                        = "#5079be";
			highlight_color_g                        = "#be7e05";
			keyboard_select_background_color         = "#608e32";
			keyboard_select_text_color               = "#4b505b";
			custom_background_color                  = "#faf9f7";
			custom_text_color                        = "#16191f";
			ui_text_color                            = "#4b505b";
			ui_background_color                      = "#eeedea";
			ui_selected_text_color                   = "#4b505b";
			ui_selected_background_color             = "#dfe0d9";
			status_bar_color                         = "#eeedea";
			status_bar_text_color                    = "#4b505b";


			# one source allowed; the raw file carries new_macro defs + active theme
			source = "${cfgDir}/user_extra.config";

			startup_commands = [ "toggle_custom_color" "toggle_statusbar" ];
		};
	};

	# new_macro can't go through programs.sioyek.config (needs two identical keys).
	# Raw sourced file instead; also pulls the light theme at startup.

	xdg.configFile."sioyek/user_extra.config".text = lib.concatStringsSep "\n" [
		"new_macro _set_light_theme setconfig_background_color(#faf9f7);setconfig_custom_color_mode_empty_background_color(#faf9f7);setconfig_page_separator_color(#faf9f7);setconfig_text_highlight_color(#aaa9a4);setconfig_visual_mark_color(#aaa9a4);setconfig_search_highlight_color(#be7e05);setconfig_link_highlight_color(#5079be);setconfig_synctex_highlight_color(#608e32);setconfig_highlight_color_a(#be7e05);setconfig_highlight_color_b(#608e32);setconfig_highlight_color_c(#3a8b84);setconfig_highlight_color_d(#d05858);setconfig_highlight_color_e(#b05ccc);setconfig_highlight_color_f(#5079be);setconfig_highlight_color_g(#be7e05);setconfig_keyboard_select_background_color(#608e32);setconfig_keyboard_select_text_color(#4b505b);setconfig_custom_background_color(#faf9f7);setconfig_custom_text_color(#16191f);setconfig_ui_text_color(#4b505b);setconfig_ui_background_color(#eeedea);setconfig_ui_selected_text_color(#4b505b);setconfig_ui_selected_background_color(#dfe0d9);setconfig_status_bar_color(#eeedea);setconfig_status_bar_text_color(#4b505b)"
		"new_macro _set_dark_theme setconfig_background_color(#141415);setconfig_custom_color_mode_empty_background_color(#141415);setconfig_page_separator_color(#141415);setconfig_text_highlight_color(#606079);setconfig_visual_mark_color(#606079);setconfig_search_highlight_color(#f3be7c);setconfig_link_highlight_color(#6e94b2);setconfig_synctex_highlight_color(#7fa563);setconfig_highlight_color_a(#f3be7c);setconfig_highlight_color_b(#7fa563);setconfig_highlight_color_c(#6ababa);setconfig_highlight_color_d(#d8647e);setconfig_highlight_color_e(#bb9dbd);setconfig_highlight_color_f(#6e94b2);setconfig_highlight_color_g(#f3be7c);setconfig_keyboard_select_background_color(#7fa563);setconfig_keyboard_select_text_color(#383848);setconfig_custom_background_color(#141415);setconfig_custom_text_color(#cdcdcd);setconfig_ui_text_color(#cdcdcd);setconfig_ui_background_color(#1c1c24);setconfig_ui_selected_text_color(#cdcdcd);setconfig_ui_selected_background_color(#383848);setconfig_status_bar_color(#1c1c24);setconfig_status_bar_text_color(#cdcdcd)"
		""
	];

	xdg.configFile."sioyek/themes/light.config".source = ./themes/light.config;
	xdg.configFile."sioyek/themes/dark.config".source  = ./themes/dark.config;
}
