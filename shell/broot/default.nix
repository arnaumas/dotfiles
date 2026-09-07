{ ... }:
{
  programs.broot = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      modal = true;

      skin = {
        default = "none none";
        tree = "ansi(8) none";
        parent = "ansi(7) none";
        file = "none none";
        directory = "ansi(4) none bold";
        exe = "ansi(2) none";
        link = "ansi(6) none";
        pruning = "ansi(8) none italic";

        selected_line = "none ansi(8)";
        char_match = "ansi(3) none bold";
        file_error = "ansi(1) none";

        input = "none none";
        flag_label = "ansi(8) none";
        flag_value = "ansi(4) none bold";

        status_normal = "none ansi(8)";
        status_italic = "ansi(4) ansi(8)";
        status_bold = "ansi(7) ansi(8) bold";
        status_error = "ansi(15) ansi(1)";
        status_job = "ansi(3) ansi(8)";

        scrollbar_track = "none none";
        scrollbar_thumb = "none none";

        help_paragraph = "none none";
        help_bold = "ansi(3) none bold";
        help_italic = "ansi(4) none italic";
        help_code = "ansi(6) ansi(8)";
        help_headers = "ansi(3) none bold";
        help_table_border = "ansi(8) none";
      };
    };
  };
}
