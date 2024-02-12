{ pkgs, config, lib, ... }:
with lib;

{
	environment.systemPackages = with pkgs; [
		zsh
		zsh-syntax-highlighting
		zsh-vi-mode
		zsh-nix-shell

		eza
		fzf
		direnv
	];

	programs.starship = {
		enable = true;
		settings = {
			format					= "$nix_shell$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$character";
			right_format			= "$status";

			directory = {
				truncation_length	= 9;
				style				= "blue";
				repo_root_style		= "yellow";
				truncate_to_repo	= false;
				read_only			= " ";
			};

			username = {
				format				= "[$user]($style)@";
				show_always			= false;
			};

			hostname = {
				format				= "[$hostname]($style) ";
				ssh_only			= true;
				trim_at				= ".";
			};

			character = {
				success_symbol		= "[❯](purple)";
				error_symbol		= "[❯](red)";
				vicmd_symbol		= "[❮](green)";
			};

			nix_shell = {
				disabled			= false;
				format				= "[(\($name\))](bold yellow) ";
			};

			git_branch = {
				format				= "[$symbol$branch]($style) ";
				style				= "bold white";
				symbol				= " ";
			};

			git_status = {
				format				= "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
				style				= "cyan";
				ignore_submodules	= false;

				conflicted			= "=";
				ahead				= "⇡";
				behind				= "⇣";
				diverged			= "⇕";
				up_to_date			= "" ;
				untracked			= "?";
				stashed				= "*";
				modified			= "!";
				staged				= "+";
				renamed				= "»";
				deleted				= "✘";
			};

			git_state = {
				format				= "\([$state( $progress_current/$progress_total)]($style)\) ";
				style				= "white";
			};

			cmd_duration = {
				format				= "[$duration]($style) ";
				style				= "yellow";
			};

			status = {
				format				= " [$status]($style) ";
				disabled			= false;
			};
		};
	};

	programs.zsh = {
		enable				= true;

		enableCompletion	= true;

		shellAliases = {
			fucking			= "sudo";

			lyrics			= "sptlrx";
			less			= "nvim -R -";

			":q"			= "exit";
			":qall"			= "exit";
			":e"			= "vi";

			open			= lib.mkIf pkgs.stdenv.isLinux "xdg-open";

			eza				= "eza --icons --git";
			ls				= "eza";
			ll				= "eza -l";
			la				= "eza -a";
			lt				= "eza --tree";
			lla				= "eza -la";
		};

		histFile			= "$HOME/.history";

		setOptions			= [
            "NoHUP"
            "autocd"

            "AppendHistory"

            "HistReduceBlanks"
            "HistIgnoreSpace"
            "HistFindNoDups"
            "HistIgnoreDups"
            "IncAppendHistory"
            "ShareHistory"
            "ExtendedHistory"
            
            "MarkDirs"
            "ListTypes"
            "LongListJobs"
            
            "CBases"			# Print hex numbers properly
            "OctalZeroes"		# Print octal numbers properly
            
            "cshNULLGlob"		# Only complain about no matches if NONE of them match
            "NumericGlobSort"	# Sort filenames with numbers numerically
 
		];

		shellInit= ''
            # Prevent prompting the user to create ~/.zshrc
            zsh-newuser-install() { :; }
            '';

		interactiveShellInit= ''
			source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

            # Use viins keymap as the default.
            bindkey -v
            
            # Allow completion to find matches regardless of case
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
            
            # Rehash automatically
            zstyle ':completion:*' rehash true
            
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
            
            EXA_ICON_SPACING=2;
            '';
	};

	# Needed for auto completion to work for zsh
	environment.pathsToLink = [ "/share/zsh" ];
}
