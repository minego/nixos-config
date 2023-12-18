{ pkgs, config, lib, ... }:
with lib;

{
	config = mkIf config.gui.enable {
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
		];

		programs.dconf.enable	= true;
		services.dbus.enable	= true;
		programs.light.enable	= true;

		fonts.packages = with pkgs; [
			# Install most through home-manager, but best to have at least one
			noto-fonts
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

