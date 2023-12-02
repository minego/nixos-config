{ config, pkgs, osConfig, lib, ... }:
with lib;

{
	home = rec {
		username		= lib.mkDefault "m";
		homeDirectory	= lib.mkDefault "/home/${config.home.username}";
	};

	# Enable DWL
	dwl.enable		= true;

	imports = [
		./modules
	];

	home.packages = with pkgs; [
		zsh
		zsh-syntax-highlighting
		zsh-vi-mode

		neofetch
		fzf
		acpi
		codespell
		mdcat
		sptlrx
		fd
		eza
		unzip
		jq
	] ++ lib.optionals osConfig.gui.enable [
		# Applications
		kitty

		spotify
		wdisplays
		slack
		bitwarden
		pavucontrol
		pamixer
		steam
		tridactyl-native
		firefox-wayland
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

	# programs.kitty.enable = true;

	programs.neovim = {
		enable			= true;
		defaultEditor	= true;
		viAlias			= true;
		vimAlias		= true;
	};

	programs.ripgrep = {
		enable			= true;
		arguments		= [ "--smart-case" ];
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

	programs.starship.enable = true;
	xdg.configFile."starship.toml".source = ./dotfiles/starship.toml;

	programs.readline.enable = true;
	home.file.".inputrc".source = ./dotfiles/inputrc;

	dconf.settings = {
		"org/gnome/desktop/interface" = {
			color-scheme = "prefer-dark";
		};
	};

	gtk = {
		enable = true;

		iconTheme = {
			name = "Papirus-Dark";
			package = pkgs.papirus-icon-theme;
		};

		theme = {
			name = "palenight";
			package = pkgs.palenight-theme;
		};

		cursorTheme = {
			name = "Numix-Cursor";
			package = pkgs.numix-cursor-theme;
		};

		gtk3.extraConfig = {
			Settings = ''
                gtk-application-prefer-dark-theme=1
			'';
		};

		gtk4.extraConfig = {
			Settings = ''
                gtk-application-prefer-dark-theme=1
			'';
		};
	};

	home.sessionVariables.GTK_THEME = "palenight";

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

