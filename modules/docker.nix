{ config, pkgs, ... }:
{
	virtualisation.docker.enable = true;
	users.users.m.extraGroups = [ "docker" ];

	virtualisation.docker.rootless = {
		enable = true;
		setSocketVariable = true;
	};
}

