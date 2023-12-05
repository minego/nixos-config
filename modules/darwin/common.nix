{ config, pkgs, lib, inputs, ... }:

{
	environment = {
		shells			= with pkgs; [ bash zsh ];
		loginShell		= pkgs.zsh;
		systemPackages	= [ pkgs.coreutils ];
		systemPath		= [ "/opt/homebrew/bin" ];
		pathsToLink		= [ "/Applications" ];
	};

	# Do this with Karabiner instead
	system.keyboard.enableKeyMapping = false;

	# Don't touch
	system.stateVersion = 4;
}

