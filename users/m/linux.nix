{ config, pkgs, lib, ... }:

{
	users.users."${config.me.user}" = {
		shell								= pkgs.zsh;
		description							= config.me.fullName;
		openssh.authorizedKeys.keys			= config.authorizedKeys.keys;

		extraGroups = [
			"networkmanager"
			"wheel"
			"video"
		];
		isNormalUser						= true;
	};

	home-manager.users."${config.me.user}"	= import ./home.nix;
}

