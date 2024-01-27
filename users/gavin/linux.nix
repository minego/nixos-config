{ config, pkgs, lib, ... }:

{
	users.users.gavin = {
		shell			= pkgs.zsh;
		description		= "Gavin Gorrell";

		extraGroups = [
			"networkmanager"
			"video"
		];
		isNormalUser	= true;
	};

	home-manager.users.gavin = import ./home.nix;
}

