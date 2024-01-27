{ config, pkgs, lib, ... }:

{
	users.users."${config.me.user}" = {
		shell								= pkgs.zsh;
		description							= config.me.fullName;
		home								= lib.mkDefault "/Users/${config.me.user}";

		openssh.authorizedKeys.keys			= config.authorizedKeys.keys;
	};

	home-manager.users."${config.me.user}"	= import ./home.nix;
}

