{ config, pkgs, ... }:

{
	users.users."${config.me.user}" = {
		shell								= pkgs.zsh;
		description							= config.me.fullName;
		openssh.authorizedKeys.keys			= config.authorizedKeys.keys;
		initialHashedPassword				= "$y$j9T$oBNqVU4HCc3Jw.H413Vfs0$YozYZu0aOlPgyZ146Z2ZOb69HSbXfw9VrO9xzz3Fw/3";

		extraGroups = [
			"networkmanager"
			"wheel"
			"video"
		];
		isNormalUser						= true;
	};

	home-manager.users."${config.me.user}"	= import ./home.nix;
}

