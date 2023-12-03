{ config, pkgs, osConfig, lib, writeShellScriptBin, ... }:
with lib;

{
	home = rec {
		username		= lib.mkDefault "m";
		homeDirectory	= lib.mkDefault "/home/${config.home.username}";
	};

	# Enable DWL
	dwl.enable = true;

	imports = [
		./modules
	];

	home.packages = with pkgs; [
		neofetch
		neovim-remote
		acpi
		codespell
		mdcat
		sptlrx
		fd
		unzip
		jq

		# Install my own custom scripts from the scripts dir
		(stdenv.mkDerivation {
			name		= "homedir-scripts";
			buildInputs	= with pkgs; [ bash ];
			src			= ./scripts;
			installPhase = ''
				mkdir -p $out/bin
				cp * $out/bin/
				chmod +x $out/bin/*
			'';
		})
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
		linuxConsoleTools # jstest
		chromium
		freerdp
	];

	home.file.neovim = {
		source = pkgs.fetchFromGitHub {
			owner	= "minego";
			repo	= "dotfiles.neovim";
			rev		= "e02dbb9";
			sha256	= "sha256-a2qZzSlJa2QbwB/dN71NCJNQwQaAdEJMAisVmexrWwI=";
		};
		target = "./.config/nvim";
	};

	programs.kitty.enable = true;

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

	xdg.mimeApps = {
		enable = true;

		defaultApplications = {
			"text/html"					= "firefox.desktop";
			"x-scheme-handler/http"		= "firefox.desktop";
			"x-scheme-handler/https"	= "firefox.desktop";
			"x-scheme-handler/about"	= "firefox.desktop";
			"x-scheme-handler/unknown"	= "firefox.desktop";
		};
	};

	home.sessionVariables = {
		BROWSER			= "${pkgs.firefox-wayland}/bin/firefox";
		DEFAULT_BROWSER	= "${pkgs.firefox-wayland}/bin/firefox";

		# Make wayland applications behave
		NIXOS_OZONE_WL	= "1";
		KEYTIMEOUT		= "1";
		VISUAL			= "nvim";
		EDITOR			= "nvim";
		LC_CTYPE		= "C";

		MALLOC_CHECK_	= "2";	# stupid linux malloc
	};

	programs.firefox.enable = true;

	# Let firefox call tridactyl's native thingy, so the config can be loaded
	home.file.tridactyl-native = {
		source = "${pkgs.tridactyl-native}//lib/mozilla/native-messaging-hosts/tridactyl.json";
		target = "./.mozilla/native-messaging-hosts/tridactyl.json";
	};
	xdg.configFile."tridactyl/tridactylrc".source = ./dotfiles/tridactylrc;

	# Don't touch
	programs.home-manager.enable = true;
	home.stateVersion = "23.11";
}

