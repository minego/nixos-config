{ config, pkgs, ... }:

rec {
	users.users.m = {
		isNormalUser	= true;
		shell			= pkgs.zsh;
		description		= "Micah N Gorrell";
		extraGroups		= [
			"networkmanager"
			"wheel"
			"video"
		];
	};

    home-manager.users.m = import ./home.nix;
}
