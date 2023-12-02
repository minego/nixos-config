{ config, pkgs, osConfig, ... }:

{
	home = {
		username		= "m";
		homeDirectory	= "/home/m";
	};

	# Enable DWL
	dwl.enable		= true;

	imports = [
		./../../modules/home
	];

	home.packages = with pkgs; [
		zsh
		zsh-syntax-highlighting
		zsh-vi-mode

		neofetch
		fzf
		acpi
		starship
		codespell
		mdcat
		ripgrep
		fd
		eza
		unzip
		jq
		light
  ] ++ lib.optionals osConfig.gui.enable [

		# Applications
		spotify
		wdisplays
		slack
		bitwarden
		pavucontrol
		pamixer
		steam
		tridactyl-native
		firefox-wayland
		thunderbird
		kitty
		linuxConsoleTools # jstest
		chromium
		freerdp
	];

	home.file = {
		neovim = {
			source = pkgs.fetchFromGitHub {
				owner	= "minego";
				repo	= "dotfiles.neovim";
				rev		= "e02dbb9";
				sha256	= "sha256-a2qZzSlJa2QbwB/dN71NCJNQwQaAdEJMAisVmexrWwI=";
			};
			target = "./.config/nvim";
		};
	};

	programs.neovim = {
		enable			= true;
		defaultEditor	= true;
		viAlias			= true;
		vimAlias		= true;
	};

	programs.git = {
		enable = true;
		lfs.enable = true;

		extraConfig = {
			url."git@gitlab.com:".insteadOf = [ "https://gitlab.com" ];
			init.defaultBranch = "main";
			pull.rebase = true;
		};

		userEmail = "m@minego.net";
		userName = "Micah N Gorrell";

		includes = [
			{
				condition = "gitdir:~/src/vaas/";
				contents.user = {
					email = "micah.gorrell@venafi.com";
					name = "Micah N Gorrell";
				};
			}

			{
				condition = "gitdir:~/src/venafi/";
				contents.user = {
					email = "micah.gorrell@venafi.com";
					name = "Micah N Gorrell";
				};
			}
		];
	};

	# Make wayland applications behave
	home.sessionVariables.NIXOS_OZONE_WL = "1";

	xdg.mimeApps.defaultApplications = {
		"text/html"					= "firefox.desktop";
		"x-scheme-handler/http"		= "firefox.desktop";
		"x-scheme-handler/https"	= "firefox.desktop";
		"x-scheme-handler/about"	= "firefox.desktop";
		"x-scheme-handler/unknown"	= "firefox.desktop";
	};
	home.sessionVariables.BROWSER			= "${pkgs.firefox-wayland}/bin/firefox";
	home.sessionVariables.DEFAULT_BROWSER	= "${pkgs.firefox-wayland}/bin/firefox";

	# Make Firefox use the native file picker
	programs.firefox.enable = true;

#	programs.zsh = {
#		enable = true;
#		shellAliases = {
#			lyrics = "sptlrx";
#		};
#	};

	# Don't touch
	programs.home-manager.enable = true;
	home.stateVersion = "23.11";
}

