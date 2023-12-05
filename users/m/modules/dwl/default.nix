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
	};
}
