{ dwl, ... }:
{ config, pkgs, stdenv, lib, fetchzip, ... }:

let
	monaspaceFont = 
		pkgs.stdenv.mkDerivation {
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

	sparkLinesFont = 
		pkgs.stdenv.mkDerivation {
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
	services.xserver = {
		enable = true;

		displayManager.sddm = {
			enable = true;
		};
	};

	environment.systemPackages = [
		# My customized build of the DWL wayland compositor
		dwl.packages.${pkgs.system}.default

		# XDG Portals
		pkgs.xdg-desktop-portal
		pkgs.xdg-desktop-portal-wlr
		pkgs.xdg-desktop-portal-gtk
		pkgs.xdg-utils

		# Tools used by my DWL/wayland setup
		pkgs.wayland
		pkgs.swayidle
		pkgs.waybar
		pkgs.wob
		pkgs.swaynotificationcenter
		pkgs.udiskie
		pkgs.playerctl
		pkgs.sptlrx
		pkgs.inotify-tools
		pkgs.mpvpaper
		pkgs.wlr-randr
		pkgs.sway-contrib.grimshot
		pkgs.sway-audio-idle-inhibit
		pkgs.lxappearance
		pkgs.bemenu
		pkgs.glib

		# Applications
		pkgs.spotify
		pkgs.firefox-wayland
		pkgs.wdisplays
		pkgs.slack
		pkgs.bitwarden
		pkgs.steam
	];

	fonts.packages = [
		pkgs.nerdfonts
		pkgs.noto-fonts
		pkgs.noto-fonts-cjk
		pkgs.noto-fonts-emoji
		pkgs.liberation_ttf
		pkgs.fira-code
		pkgs.fira-code-symbols
		pkgs.mplus-outline-fonts.githubRelease
		pkgs.dina-font
		pkgs.proggyfonts
		pkgs.terminus_font
		monaspaceFont
		sparkLinesFont
	];

	# Make wayland applications behave
	environment.sessionVariables.NIXOS_OZONE_WL = "1";

	# XDG Desktop Portal
	services.dbus.enable = true;
	xdg.portal = {
		enable = true;
		wlr.enable = true;

		xdgOpenUsePortal = true;

		extraPortals = with pkgs; [
			xdg-desktop-portal-wlr
			xdg-desktop-portal-gtk
		];

	};

	environment.shellAliases = {
		lyrics = "sptlrx";
	};

	programs.dconf.enable = true;
}

