{ lib, config, ... }:
{
	home.file = {
		".editrc".source = ./.editrc;
		".cache/zsh/.keep".text = "";
	};

	xdg.configFile = {
		"zsh/.inputrc".source = ./.inputrc;
	};

	programs.zsh = {
		enable = true;
		dotDir = "${config.xdg.configHome}/zsh";

		autocd = true;

		shellGlobalAliases = {
			"..." = "../..";
			"...." = "../../..";
			"....." = "../../../..";
		};


		# everything irreducibly imperative (custom widgets, zle hooks, zstyles,
		# functions). mkAfter so it runs after hm's compinit + plugin sourcing, so
		# our keybinds (e.g. Tab) win over fzf-tab's own.
		initContent = lib.mkAfter ''
			# aliases -->
			mkd() {
				mkdir -pv -- "$1" && cd -- "$1"
			}
			# <--


			# keybinds: free these for terminal navigation -->
			bindkey -r ^J
			bindkey -r ^K
			bindkey -r ^L
			bindkey -r ^H
			# <--

			# refs picker -->
			export REFS_DIR="$HOME/documents/refs"

			refs() {
				local -a papers
				papers=(''${(f)"$(printf '%s\n' $REFS_DIR/*.pdf \
					| sed "s|^$REFS_DIR/||" \
					| fzf --multi \
					  --prompt='refs > ' \
						--preview='refs-bib {}' \
						--preview-window='down,80%,wrap' \
						--height=30)"})
				[[ -z $papers ]] && return

				local f first=1
				for f in "''${papers[@]}"; do
					if (( first )); then
						( sioyek "$REFS_DIR/$f" >/dev/null 2>&1 & )
						first=0
					else
						sleep 1
						( sioyek --reuse-window "$REFS_DIR/$f" >/dev/null 2>&1 & )
					fi
				done
			}

			refs-widget() { refs; zle reset-prompt }
			zle -N refs-widget
			bindkey -M viins '^o' refs-widget
			bindkey -M vicmd '^o' refs-widget
			# <--

		'';
	};

	imports = [
		./prompt
		./completion
		./syntax.nix
		./history.nix
		./vi.nix
	];
}
