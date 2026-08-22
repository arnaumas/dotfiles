{ pkgs, lib, config, ... }:
{
	home.file = {
		".editrc".source = ./.editrc;
		# ensure the zsh cache dir exists for HISTFILE + zcompdump
		".cache/zsh/.keep".text = "";
	};

	xdg.configFile = {
		"zsh/.inputrc".source = ./.inputrc;
	};

	# bat -->
	programs.bat = {
		enable = true;
		config.theme = "ansi16";
	};
	# <--

	# ripgrep -->
	# replaces the raw rgconf + RIPGREP_CONFIG_PATH; hm writes the config file
	# and points RIPGREP_CONFIG_PATH at it.
	programs.ripgrep = {
		enable = true;
		arguments = [
			"--colors=match:none"
			"--colors=match:fg:yellow"
			"--colors=match:style:bold"

			"--colors=path:none"
			"--colors=path:fg:blue"

			"--colors=line:none"
			"--colors=line:fg:black"
			"--colors=line:style:intense"
			"--colors=column:none"
			"--colors=column:fg:black"
			"--colors=column:style:intense"
		];
	};
	# <--

	# zsh -->
	programs.zsh = {
		enable = true;
		dotDir = ".config/zsh";                       # preserve ZDOTDIR layout

		autocd = true;
		defaultKeymap = "viins";                      # vi mode (was `bindkey -v`)

		# match the old raw config exactly: no dedup, no share, incremental append
		# (inc_append_history is set in initContent since hm only offers share).
		history = {
			path = "${config.xdg.cacheHome}/zsh/history";
			size = 10000000;
			save = 10000000;
			share = false;
			extended = false;
			ignoreDups = false;
			ignoreAllDups = false;
			ignoreSpace = false;
			expireDuplicatesFirst = false;
		};

		shellAliases = {
			cp = "cp -iv";
			mv = "mv -iv";
			rm = "rm -Ivr";
			vim = "nvim";
			python = "python3";
		};

		shellGlobalAliases = {
			"..." = "../..";
			"...." = "../../..";
			"....." = "../../../..";
		};

		# plugins, nix-managed (flake-locked) instead of git-cloned on demand
		autosuggestion.enable = true;
		syntaxHighlighting = {
			enable = true;
			highlighters = [ "main" "brackets" ];
			# map onto the same ANSI slots as the editor: command position blue;
			# strings green; comments yellow; existing paths underlined; globs cyan.
			styles = {
				command = "fg=4";
				builtin = "fg=4";
				function = "fg=4";
				alias = "fg=4";
				precommand = "fg=4";
				single-quoted-argument = "fg=2";
				double-quoted-argument = "fg=2";
				dollar-quoted-argument = "fg=2";
				comment = "fg=3";
				path = "underline";
				globbing = "fg=6";
				unknown-token = "none";
				single-hyphen-option = "none";
				double-hyphen-option = "none";
				commandseparator = "none";
				redirection = "none";
				reserved-word = "none";
				default = "none";
				cursor-matchingbracket = "fg=10,underline";
				bracket-level-1 = "fg=7";
				bracket-level-2 = "fg=7";
				bracket-level-3 = "fg=7";
				bracket-level-4 = "fg=7";
				bracket-error = "fg=7";
			};
		};

		# preserve the old compinit: hidden-file globbing, cache in XDG_CACHE_HOME
		completionInit = ''
			_comp_options+=(globdots)
			autoload -U compinit
			compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
			zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
		'';

		# was ~/.zshenv (raw)
		envExtra = ''
			# move configuration files to ~/.config
			export XDG_CONFIG_HOME="$HOME/.config"
			export XDG_DATA_HOME="$HOME/.local/share"
			export XDG_CACHE_HOME="$HOME/.cache"
			export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
			export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

			export EDITOR="nvim"
			export VISUAL="nvim"
			export MANPAGER='nvim +Man!'
			export MANWIDTH=999

			export PYTHON_HISTORY="$XDG_CACHE_HOME/python/history"
			export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

			export HOMEBREW_NO_AUTO_UPDATE=1
		'';

		# was ~/.config/zsh/.zprofile (raw)
		profileExtra = ''
			# homebrew: sets HOMEBREW_PREFIX, MANPATH, INFOPATH, fpath and prepends
			# /opt/homebrew/{bin,sbin}. The nix block below prepends the nix profiles
			# ahead of these, so nix wins; brew stays on PATH for not-yet-migrated tools.
			eval "$(/opt/homebrew/bin/brew shellenv)"
			path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
			path+=("$HOME/.local/bin")                           # claude code
			path+=("/Applications/Obsidian.app/Contents/MacOS")  # obsidian

			# nix profiles win over homebrew -->
			path=(
				$HOME/.local/state/nix/profiles/home-manager/home-path/bin  # standalone home-manager
				/etc/profiles/per-user/$USER/bin                            # darwin home (useUserPackages)
				/run/current-system/sw/bin                                  # darwin systemPackages
				$path
			)
			typeset -U path
			# <--

			export SHELL_SESSIONS_DISABLE=1
		'';

		# everything irreducibly imperative (custom widgets, zle hooks, zstyles,
		# functions). mkAfter so it runs after hm's compinit + plugin sourcing, so
		# our keybinds (e.g. Tab) win over fzf-tab's own.
		initContent = lib.mkAfter ''
			# general -->
			autoload -U colors && colors            # enable colors
			zle_highlight=('paste:none')            # don't highlight pasted text
			setopt inc_append_history               # append to history without exiting
			# <--

			# history search: use existing string to search -->
			autoload -Uz up-line-or-beginning-search
			autoload -Uz down-line-or-beginning-search
			zle -N up-line-or-beginning-search
			zle -N down-line-or-beginning-search
			bindkey -M viins "^[[A" up-line-or-beginning-search
			bindkey -M viins "^[[B" down-line-or-beginning-search
			# <--

			# aliases -->
			# ll: hidden files, dir slashes, no total/DS_Store, no perms
			alias ll"=ls -ohAF --color=always | sed '1d;/.DS_Store/d;s/^.\{11\}[[:space:]]*[[:digit:]]*[[:space:]]//g'"
			mkd() {
				mkdir -pv -- "$1" && cd -- "$1"
			}
			# <--

			# completion zstyles -->
			# tried in order, each only if the previous found nothing; fuzzy last
			zstyle ':completion:*' matcher-list \
				''' \
				'm:{a-z}={A-Z}' \
				'r:|[._-]=* r:|=*' \
				'r:|?=**'

			# candidate colors: dir=blue, symlink=magenta (files stay default)
			zstyle ':completion:*' list-colors \
				'di=34' 'ln=35' 'so=32' 'pi=33' 'ex=31' \
				'bd=34;46' 'cd=34;43' 'su=30;41' 'sg=30;46' 'tw=30;42' 'ow=30;43'
			export LS_COLORS='rs=0:no=0:fi=0:di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

			# cd: prefer real local dirs over $cdpath, and allow ../
			zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack
			zstyle ':completion:*' special-dirs false
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

			# prompt: pure -->
			fpath+=(${pkgs.pure-prompt}/share/zsh/site-functions)
			export PURE_PROMPT_SYMBOL='>'
			export PURE_PROMPT_VICMD_SYMBOL='<'
			export PURE_GIT_UP_ARROW='↑'
			export PURE_GIT_DOWN_ARROW='↓'
			autoload -U promptinit; promptinit
			prompt pure

			# override Pure colors to use the ANSI palette (dirty-git '*' defaults
			# to a hardcoded 256-color; use palette yellow instead).
			zstyle ':prompt:pure:git:dirty' color yellow
			zstyle ':prompt:pure:git:branch' color default
			zstyle ':prompt:pure:host' color 7
			zstyle ':prompt:pure:user' color 7
			zstyle ':prompt:pure:virtualenv' color 7

			# print newline after command but not first line
			new-line() {
				if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
					NEW_LINE_BEFORE_PROMPT=1
				elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
					echo ""
				fi
			}
			autoload -Uz add-zsh-hook
			add-zsh-hook precmd new-line

			# redefine clear so it does not add a newline
			alias clear="unset NEW_LINE_BEFORE_PROMPT && clear"
			# <--

			# vi mode -->
			export KEYTIMEOUT=1     # do not wait to enter vi mode

			bindkey "^?" backward-delete-char
			bindkey -M viins "^[[3~" delete-char

			# change cursor shape for different vi modes
			beam-cursor() { echo -ne '\e[6 q' }
			block-cursor() { echo -ne '\e[2 q' }
			function switch-cursor () {
				case $KEYMAP in
					vicmd) block-cursor;;             # block cursor in normal mode
					viins|main) beam-cursor;;         # beam cursor in insert mode
				esac
			}
			zle -N switch-cursor
			zle -N beam-cursor
			add-zle-hook-widget zle-keymap-select switch-cursor
			add-zle-hook-widget zle-line-init beam-cursor
			add-zsh-hook preexec beam-cursor

			# use existing string to search history also in vi mode
			bindkey -M vicmd "k" up-line-or-beginning-search
			bindkey -M vicmd "j" down-line-or-beginning-search

			# edit line in vim with ctrl-e
			autoload edit-command-line; zle -N edit-command-line
			bindkey '^e' edit-command-line
			bindkey -M vicmd '^[[3~' vi-delete-char
			bindkey -M visual '^[[3~' vi-delete
			bindkey -M vicmd '^e' edit-command-line
			# <--

			# zsh-autosuggestions -->
			ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=7"          # recessive grey (matches palette)
			ZSH_AUTOSUGGEST_STRATEGY=(unique_completion)
			ZSH_AUTOSUGGEST_USE_ASYNC=1
			ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30              # no suggestions on very long lines

			# suggest only unambiguous completions (upstream inserts the first blindly)
			_zsh_autosuggest_capture_postcompletion() {
				(( compstate[nmatches] == 1 )) && compstate[insert]=1 || unset 'compstate[insert]'
				unset 'compstate[list]'
			}

			# an untouched buffer means nothing was inserted
			_zsh_autosuggest_strategy_unique_completion() {
				_zsh_autosuggest_strategy_completion "$@"
				[[ "$suggestion" == "$1" ]] && unset suggestion
			}

			# <Tab> accepts the suggestion if there is one, else opens fzf-tab
			typeset -ga FZF_DEEP_CMDS=(vim nvim vi cd)
			tab-accept-or-complete() {
				[[ -n "$POSTDISPLAY" ]] && { zle autosuggest-accept; return }

				local words=(''${(z)LBUFFER}) cmd
				cmd=$words[1]

				# still on the first word -> command completion
				if (( ''${#words} <= 1 )) && [[ ''${LBUFFER[-1]} != ' ' ]]; then
					zle fzf-tab-complete; return
				fi

				if (( ''${FZF_DEEP_CMDS[(Ie)$cmd]} )) || [[ -z $_comps[$cmd] || $_comps[$cmd] == _default ]]; then
					zle fzf-completion
				else
					zle fzf-tab-complete
				fi
			}
			zle -N tab-accept-or-complete
			bindkey -M viins '^I' tab-accept-or-complete

			# misc -->
			# clear half the screen
			# TODO: Fix this
			clear-half() {
				CURSOR_PREV="$CURSOR"
				HALFLINES=$(( (LINES-1)/2 ))
				for i in {1..$HALFLINES}; do echo; done
				if [[ $? -eq 0 ]]; then
					tput cup $(( HALFLINES )) $((CURSOR_PREV + 2))
				else
					tput cup $(( LINES - HALFLINES )) $((CURSOR_PREV + 3 + $#?))
				fi
			}
			zle -N clear-half
			bindkey -M vicmd "zz" clear-half
			# <--
		'';
	};
	# <--
}
