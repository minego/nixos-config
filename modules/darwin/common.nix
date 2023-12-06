{ config, pkgs, lib, inputs, ... }:

{
	environment = {
		shells				= with pkgs; [ bash zsh ];
		loginShell			= pkgs.zsh;
		systemPackages		= [ pkgs.coreutils ];
		pathsToLink			= [ "/Applications" ];
	};

	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable = true;

	# Do this with Karabiner instead
	system.keyboard.enableKeyMapping = false;

	# Don't touch
	system.stateVersion = 4;
}

