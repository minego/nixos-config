{ globals, config, pkgs, lib, ... }:

{
	users.users.m = {
		shell			= pkgs.zsh;
		description		= "Micah N Gorrell";
		home			= lib.mkDefault "/Users/m";

		openssh.authorizedKeys.keys = config.authorizedKeys.keys;
	};

	home-manager.users.m = import ./home.nix;
}

