{ config, pkgs, lib, inputs, ... }:

{
	environment = {
		shells					= with pkgs; [ bash zsh ];
		loginShell				= pkgs.zsh;
		systemPackages			= with pkgs; [
			coreutils
			syncthing

			# I don't love having these installed, but they make development
			# easier since I don't have to install them for every little thing
			cmake
			ninja
			openssl
			openssl.dev
			pkg-config

			virt-viewer
		];
		pathsToLink				= [ "/Applications" ];

		variables = {
			LC_ALL				= "en_US.UTF-8"; 
			LC_ADDRESS			= "en_US.UTF-8";
			LC_IDENTIFICATION	= "en_US.UTF-8";
			LC_MEASUREMENT		= "en_US.UTF-8";
			LC_MONETARY			= "en_US.UTF-8";
			LC_NAME				= "en_US.UTF-8";
			LC_NUMERIC			= "en_US.UTF-8";
			LC_PAPER			= "en_US.UTF-8";
			LC_TELEPHONE		= "en_US.UTF-8";
			LC_TIME				= "en_US.UTF-8";
		};
	};

	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable	= true;

	# Do this with Karabiner instead
	system.keyboard.enableKeyMapping = false;

	# Don't touch
	system.stateVersion			= 4;
}

