{ config, pkgs, ... }:
{
	services.sabnzbd = {
		enable			= true;
		group			= "plex";
		configFile		= "/var/lib/sabnzbd/sabnzbd.ini";
	};

	networking.firewall.allowedTCPPorts = [ 8080 9090 ];

	environment.systemPackages = with pkgs; [
		par2cmdline
	];

	# Reverse proxy with subdir
	services.nginx.virtualHosts."minego.net" = {
		locations."/sabnzbd" = {
			proxyPass = "http://127.0.0.1:8080";
			proxyWebsockets = true;
			extraConfig = "proxy_pass_header Authorization;";
		};
	};

}

