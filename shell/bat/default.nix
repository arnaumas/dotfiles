{ ... }: {
	programs.bat = {
		enable = true;
		config = {
			theme = "ansi16";
			style = "header,snip";
		};
		themes.ansi16 = {
			src = ./.;
			file = "ansi16.tmTheme";
		};
	};
}
