{ config, pkgs, lib, ... }:
with lib;

{
	# Options consumers of this module can set
	options = {
		gui = {
			enable = mkEnableOption "GUI";
		};

		steam = {
			enable = mkEnableOption "Steam";
		};

		printer = {
			enable = mkEnableOption "Printer support";
		};

		laptop = {
			enable = mkEnableOption "Laptop specific options";
		};
	};

	config = mkIf config.gui.enable {
		environment.systemPackages = with pkgs; [
			# virt-manager
			virt-viewer

			kitty
			dwl
			wayland
			bemenu

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
			stable.j4-dmenu-desktop
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

