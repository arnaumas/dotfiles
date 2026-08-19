{ ... }:
{
	home.file = {
		".zshenv".source = ./.zshenv;
		".editrc".source = ./.editrc;
	};

	xdg.configFile = {
		"zsh/.zshrc".source   = ./.zshrc;
		"zsh/.zprofile".source = ./.zprofile;
		"zsh/.inputrc".source  = ./.inputrc;
		"zsh/rgconf".source    = ./rgconf;
		"zsh/prompts/pure/async".source              = ./prompts/pure/async;
		"zsh/prompts/pure/prompt_pure_setup".source  = ./prompts/pure/prompt_pure_setup;
	};
}
