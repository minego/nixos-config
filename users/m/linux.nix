{ globals, config, pkgs, lib, ... }:

{
	users.users.m = {
		shell			= pkgs.zsh;
		description		= "Micah N Gorrell";

		openssh.authorizedKeys.keys = config.authorizedKeys.keys;

		extraGroups = [
			"networkmanager"
			"wheel"
			"video"
		];
		isNormalUser	= true;
	};
}

