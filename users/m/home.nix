{ config, pkgs, osConfig, lib, writeShellScriptBin, ... }:
with lib;

{
	home = rec {
		username		= lib.mkDefault "m";
		homeDirectory	= 
				if
					pkgs.stdenv.isDarwin
				then
					lib.mkDefault "/Users/${config.home.username}"
				else
					lib.mkDefault "/home/${config.home.username}";
	};

	# Enable DWL
	dwl.enable = true;

	imports = [
		./modules
	];

	home.packages = with pkgs; [
		neofetch
		neovim-remote
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

	# Kitty is configured in a module, but only if enabled
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
		enable			= true;
		lfs.enable		= true;

		userEmail		= "m@minego.net";
		userName		= "Micah N Gorrell";

		extraConfig = {
			url."git@gitlab.com:".insteadOf = [ "https://gitlab.com" ];
			init.defaultBranch = "main";
			pull.rebase	= true;
		};

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

	home.file.ssh-config = {
		source = ./dotfiles/ssh-config;
		target = "./.ssh/config";
	};

	home.file.ssh-rc = {
		source = ./dotfiles/ssh-rc;
		target = "./.ssh/rc";
	};

	programs.readline.enable = true;
	home.file.".inputrc".source = ./dotfiles/inputrc;

	dconf.settings = mkIf pkgs.stdenv.isLinux {
		"org/gnome/desktop/interface" = {
			color-scheme = "prefer-dark";
		};
	};

	gtk = mkIf pkgs.stdenv.isLinux {
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

	# Don't touch
	programs.home-manager.enable = true;
	home.stateVersion = "23.11";
}

