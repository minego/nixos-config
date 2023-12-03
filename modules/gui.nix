{ config, pkgs, lib, fetchzip, ... }:
with lib;

{
	# Options consumers of this module can set
	options.gui = {
		enable = mkEnableOption "GUI";
	};

	config = mkIf config.gui.enable {
		environment.systemPackages = with pkgs; [
			# XDG Portals
			xdg-desktop-portal
			xdg-desktop-portal-wlr
			xdg-desktop-portal-gtk
			xdg-utils
		];

		programs.light.enable = true;

		fonts.packages = with pkgs; [
			# Install most through home-manager, but best to have at least one
			noto-fonts
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

