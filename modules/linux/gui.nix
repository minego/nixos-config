{ pkgs, config, lib, ... }:
with lib;

{
	imports = [
		./firefox.nix
		# ./chromium.nix
	];

	# Importing this module should automatically turn this option on
	config.gui.enable = mkForce true;

	config = {
		# This is required to use the lldb-vscode DAP to debug on Linux, and I
		# tend to need to do that on any system that is a "desktop" so that is
		# why I put this here.
		boot.kernel.sysctl."kernel.yama.ptrace_scope" = mkForce 0;

		environment.systemPackages = with pkgs; [
			# XDG Portals
			xdg-desktop-portal
			xdg-desktop-portal-wlr
			xdg-desktop-portal-gtk
			xdg-utils

			kitty

			pavucontrol
			pamixer
			freerdp
			tigervnc
			remmina
			sway-contrib.grimshot
		];

		programs.dconf.enable	= true;
		services.dbus.enable	= true;
		programs.light.enable	= true;

		fonts.packages = with pkgs; [
			nerdfonts
			noto-fonts
			noto-fonts-cjk
			noto-fonts-emoji
			liberation_ttf
			fira-code
			fira-code-symbols
			mplus-outline-fonts.githubRelease
			proggyfonts
			terminus_font

			monaspace
			sparklines
		];
		
		fonts.fontconfig.defaultFonts = {
			serif		= [ "Noto Serif" ];
			sansSerif	= [ "Monaspace Neon Light" "Noto Sans" ];
		};

		# This is needed for swaylock to work properly
		security.pam.services.swaylock = {};
		security.pam.loginLimits = [
			{ domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
		];

		# XDG Desktop Portal
		# TODO Find a way to do this through home-manager, since these options
		# will not be right for other window managers
		xdg.portal = {
			enable				= true;
			wlr.enable			= true;

			xdgOpenUsePortal	= false;

			config.common = {
				default			= [ "wlr" "gtk" ];
			};
		};
	};
}

