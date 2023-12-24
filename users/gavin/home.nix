{ config, pkgs, osConfig, lib, ... }:
with lib;

{
	home = rec {
		username		= lib.mkDefault "gavin";
		homeDirectory	= 
				if
					pkgs.stdenv.isDarwin
				then
					lib.mkDefault "/Users/${config.home.username}"
				else
					lib.mkDefault "/home/${config.home.username}";
	};

	firefox.enable = true;

	imports = [
		./modules
	];

	home.packages = with pkgs; [

	] ++ lib.optionals (osConfig.gui.enable && pkgs.stdenv.isLinux) [
		chromium
		spotify
		mpv
		vlc
		pavucontrol
		pamixer
		linuxConsoleTools # jstest
		libsForQt5.kolourpaint
		tiled
		godot_4
	];

	# Kitty is configured in a module, but only if enabled
	programs.kitty.enable = true;

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

	# On darwin the terminfo related environment variables don't seem to get
	# set early enough to be used via ssh.
	#
	# Just make the symlink in our home dir to ensure we can ssh from kitty
	home.file.kitty-terminfo1 = {
		source = "${pkgs.kitty.terminfo.outPath}/share/terminfo/78/xterm-kitty";
		target = "./.terminfo/xterm-kitty";
	};

	home.file.kitty-terminfo2 = {
		source = "${pkgs.kitty.terminfo.outPath}/share/terminfo/78/xterm-kitty";
		target = "./.terminfo/78/xterm-kitty";
	};

	# Don't touch
	programs.home-manager.enable = true;
	home.stateVersion = "23.11";
}

