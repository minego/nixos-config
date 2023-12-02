{ config, pkgs, lib, fetchzip, ... }:
with lib;

let
	monaspaceFont = pkgs.stdenv.mkDerivation {
		name	= "monaspace";
		version	= "1.000";

		src		= pkgs.fetchFromGitHub {
			owner	= "githubnext";
			repo	= "monaspace";
			rev		= "2bddc16670ec9cf00435a1725033f241184dedd1";
			sha256	= "sha256-YgpK+a66s8YiJg481uFlRKUvu006Z2sMOpuvPFcDJH4=";
		};

		installPhase = ''
			mkdir -p $out/share/fonts/OTF/
			cp -r fonts/otf/* $out/share/fonts/OTF/
		'';
	};

	sparkLinesFont = pkgs.stdenv.mkDerivation {
		name	= "sparklines";
		version	= "2.0";

		src		= pkgs.fetchzip {
			url			= "https://github.com/aftertheflood/sparks/releases/download/v2.0/Sparks-font-complete.zip";
			stripRoot	= false;
			hash		= "sha256-xp/rCZpitX2IZO1Tvl3Me1WSPsxy55BDDuoQzQGBlII=";
		};

		installPhase = ''
			mkdir -p $out/share/fonts/OTF/
			cp -r Sparks/*.otf $out/share/fonts/OTF/
		'';
	};
in
{
	# Options consumers of this module can set
	options.gui = {
		enable = mkEnableOption "GUI";
	};

	config = mkIf config.gui.enable {
		environment.systemPackages = with pkgs; [
		];

		fonts.packages = with pkgs; [
			nerdfonts
			noto-fonts
			noto-fonts-cjk
			noto-fonts-emoji
			liberation_ttf
			fira-code
			fira-code-symbols
			mplus-outline-fonts.githubRelease
			dina-font
			proggyfonts
			terminus_font
			monaspaceFont
			sparkLinesFont
		];
		fonts.fontconfig.defaultFonts = {
			serif = [ "Noto Serif" ];
			sansSerif = [ "Monaspace Neon Light" "Noto Sans" ];
		};

		# This is needed for swaylock to work properly
		security.pam.services.swaylock = {};
		security.pam.loginLimits = [
			{ domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
		];

		# Install steam globally, because we're all gonna want it.
		programs.steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
		};

		hardware.steam-hardware.enable = true;

		programs.dconf.enable = true;
		services.dbus.enable = true;

		# Make Firefox use the native file picker
		programs.firefox.preferences.widget.use-xdg-desktop-portal.file-picker = 1;

		# XDG Desktop Portal
		# TODO Find a way to do this through home-manager, since these options
		# will not be right for other window managers
		xdg.portal = {
			enable = true;
			wlr.enable = true;

			# xdgOpenUsePortal = true;

			extraPortals = with pkgs; [
				xdg-desktop-portal-wlr
				# xdg-desktop-portal-gtk
			];

			# Keep the behavior as it was prior to xdg-desktop-portal 1.17 until
			# I can find better documentation for the xdg.portal.config option
			config.common.default = "*";
		};
	};
}

