{ config, pkgs, lib, osConfig, ... }:
with lib;

{
	# Options consumers of this module can set
	options.dwl = {
		enable = mkEnableOption "DWL";
	};

	config = mkIf (config.dwl.enable && osConfig.gui.enable && pkgs.stdenv.isLinux) {
		home.packages = with pkgs; [
			dwl
			wayland

			# Tools used by my DWL/wayland setup
			swayidle
			swaylock-effects
			wob
			udiskie
			playerctl
			inotify-tools
			mpvpaper
			wlr-randr
			sway-contrib.grimshot
			sway-audio-idle-inhibit
			bemenu
			j4-dmenu-desktop
			light

			# Applications
			wdisplays
			pavucontrol
			pamixer
			kitty
			freerdp
			tigervnc
		];

		home.sessionVariables = {
			BROWSER			= "${pkgs.firefox}/bin/firefox";
			DEFAULT_BROWSER	= "${pkgs.firefox}/bin/firefox";

			# Make wayland applications behave
			NIXOS_OZONE_WL	= "1";

			MALLOC_CHECK_	= "2";	# stupid linux malloc
		};
	};
}
