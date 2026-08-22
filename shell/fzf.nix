{ pkgs, lib, ... }:
let
	colors = {
		"fg"             = "-1";
		"list-fg"        = "0";
		"bg"             = "-1";
		"fg+"            = "-1:bold";
		"bg+"            = "8";
		"hl"             = "3:bold";
		"hl+"            = "3:bold";
		"query"          = "-1:regular";
		"prompt"         = "4:regular";
		"marker"         = "3:bold";
		"gutter"         = "-1";
		"pointer"        = "4:regular";
		"preview-border" = "7";
	};

	colorFlag = "--color=base16," + lib.concatStringsSep "," (lib.mapAttrsToList (name: value: "${name}:${value}") colors);

	defaultOpts = [
		colorFlag
		"--height=~8"
		"--layout=reverse"
		"--padding=0,0,0,1"
		"--border=none"
		"--pointer=''"
		"--marker='> '"
		"--cycle"
		"--no-scrollbar"
		"--no-info"
		"--no-separator"
		"--preview-border=line"
		"--preview-window=noinfo"
	];

	fzf = pkgs.symlinkJoin {
		name = "fzf-wrapped";
		paths = [ pkgs.fzf pkgs.fzf.man ];
		nativeBuildInputs = [ pkgs.makeWrapper ];
		postBuild = ''
			wrapProgram $out/bin/fzf \
				--add-flags "${lib.concatStringsSep " " defaultOpts}"
		'';
		inherit (pkgs.fzf) version;
		meta.mainProgram = "fzf";
	};

in {
	programs.fzf = {
		enable = true;
		package = fzf;
		enableZshIntegration = true;                 # replaces `source <(fzf --zsh)`
	};

	programs.zsh.plugins = [
		{
			name = "fzf-tab";
			src = pkgs.zsh-fzf-tab;
			file = "share/fzf-tab/fzf-tab.plugin.zsh";
		}
	];

	programs.zsh.initContent = lib.mkAfter ''
		# fzf-tab -->
		# empty (but set) trigger so `fzf-completion` fires on a bare Tab. the Tab
		# widget in the zsh module decides when to call it.
		export FZF_COMPLETION_TRIGGER=
		zstyle ':fzf-tab:*' switch-group '^' '+'
		zstyle ':fzf-tab:*' continuous-trigger '/'
		zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -p --color=always -- "$realpath" 2>/dev/null'
		zstyle ':fzf-tab:complete:*:*' fzf-preview \
			'[[ -d "$realpath" ]] && ls -p --color=always -- "$realpath" 2>/dev/null || bat --color=always --style=plain --theme=ansi16 -- "$realpath" 2>/dev/null || true'
		# <--

		export FZF_COMPLETION_OPTS='--ansi --height=40%'
		_fzf_compgen_path() { fd --strip-cwd-prefix --hidden --follow --color=always --exclude .git }
		_fzf_compgen_dir()  { fd --strip-cwd-prefix --type d --hidden --follow --color=always --exclude .git }
		_fzf_comprun() {
			local command=$1; shift
			case "$command" in
				cd) fzf --preview 'ls -p --color=always -- {} 2>/dev/null' "$@" ;;
				*)  fzf --preview '[[ -d {} ]] && ls -p --color=always -- {} 2>/dev/null || bat --color=always --style=plain -- {} 2>/dev/null || true' "$@" ;;
			esac
		}
	'';
}
