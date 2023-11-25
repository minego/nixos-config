{ config, pkgs, ... }:
{
	services.plex = {
		enable			= true;
		openFirewall	= true;
		user			= "plex";
		group			= "plex";

		dataDir			= "/var/lib/plex";
	};
}

