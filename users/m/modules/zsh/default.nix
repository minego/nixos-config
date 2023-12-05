{ config, pkgs, lib, osConfig, inputs, ... }:
with lib;

{
	home.packages = with pkgs; [
		zsh
		zsh-syntax-highlighting
		zsh-vi-mode
		zsh-system-clipboard
		zsh-nix-shell

		mdcat
	];


	programs.starship.enable = true;
	xdg.configFile."starship.toml".source = ./../../dotfiles/starship.toml;

	programs.zsh = {
		enable				= true;

		defaultKeymap		= "viins";
		enableCompletion	= true;
		autocd				= true;

		sessionVariables	= {
			EXA_ICON_SPACING= "2";
		};

		shellAliases = {
			fucking			= "sudo";

			lyrics			= "sptlrx";
			less			= "nvim -R -";

			":q"			= "exit";
			":qall"			= "exit";
			":e"			= "vi";

			open			= lib.mkIf pkgs.stdenv.isLinux "xdg-open";
		};

		history.path		= "$HOME/.history";

		initExtra			= ''
            # Allow completion to find matches regardless of case
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
            
            # Rehash automatically
            zstyle ':completion:*' rehash true
            
            # Don't kill background jobs when I exit
            setopt NoHUP
            
            setopt AppendHistory
            
            setopt HistReduceBlanks
            setopt HistIgnoreSpace
            setopt HistFindNoDups
            setopt HistIgnoreDups
            setopt IncAppendHistory
            setopt ShareHistory
            setopt ExtendedHistory
            
            setopt MarkDirs
            setopt ListTypes
            setopt LongListJobs
            
            setopt CBases			# Print hex numbers properly
            setopt OctalZeroes		# Print octal numbers properly
            
            # setopt Correct
            setopt cshNULLGlob		# Only complain about no matches if NONE of them match
            setopt NumericGlobSort	# Sort filenames with numbers numerically
            
            unsetopt MenuComplete	# I don't really like the menu, and it has a habit of
            unsetopt AutoMenu		# selecting the first match automatically.  I hate that.
            
            unsetopt Beep			# SHUT UP!
            
            # Only show entries in the history that match the current line
            autoload up-line-or-beginning-search
            autoload down-line-or-beginning-search
            zle -N up-line-or-beginning-search
            zle -N down-line-or-beginning-search
            bindkey "^[[A" up-line-or-beginning-search
            bindkey "^[[B" down-line-or-beginning-search
            bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
            bindkey "$terminfo[kcud1]" down-line-or-beginning-search
            bindkey -M vicmd "k" up-line-or-beginning-search
            bindkey -M vicmd "j" down-line-or-beginning-search
            
            # Suffix Aliases (run a file as if it was a command for a specific extension)
            alias -s c=nvim
            alias -s h=nvim
            alias -s go=nvim
            alias -s txt=nvim
            alias -s pdf=zathura
            alias -s png=feh
            alias -s gif=feh
            alias -s jpg=feh
            alias -s md="glow -p"
            
            # Teach myself some things...
            if [[ ! -n "$NO_HINTS" ]]; then
            	mdcat ~/.zsh.hints.md
            fi
            '';
	};

	programs.eza = {
		enable				= true;
		enableAliases		= true;
		git					= true;
		icons				= true;
	};

	programs.fzf = {
		enable				= true;
	};
	programs.direnv = {
		enable				= true;
	};
}
