{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	# Options consumers of this module can set
	options.dwl = {
		enable = mkEnableOption "DWL";
	};

	config = mkIf (config.dwl.enable && osConfig.gui.enable) {
		home.packages = with pkgs; [
			dwl

			# XDG Portals
			xdg-desktop-portal
			xdg-desktop-portal-wlr
			xdg-desktop-portal-gtk
			xdg-utils

			# Tools used by my DWL/wayland setup
			wayland
			swayidle
			swaylock-effects
			waybar
			wob
			swaynotificationcenter
			udiskie
			playerctl
			sptlrx
			inotify-tools
			mpvpaper
			wlr-randr
			sway-contrib.grimshot
			sway-audio-idle-inhibit
			lxappearance
			bemenu
			j4-dmenu-desktop
			glib

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
	};
}
