{ config, pkgs, ... }:
{
	services.sabnzbd = {
		enable			= true;

		user			= "plex";
		group			= "plex";

		configFile		= "/var/lib/sabnzbd/sabnzbd.ini";
	};

	networking.firewall.allowedTCPPorts = [ 8080 9090 ];

	environment.systemPackages = with pkgs; [
		par2cmdline
	];
}

