{ config, pkgs, ... }:
{
	services.sonarr = {
		enable			= true;
		openFirewall	= true;
		group			= "plex";
	};

	# Reverse proxy with subdir
    services.nginx.virtualHosts."${config.services.nginx.hostname}" = {
		locations."/sonarr" = {
			proxyPass = "http://127.0.0.1:8989";

			extraConfig = ''
				proxy_set_header   Host $proxy_host;
				proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
				proxy_set_header   X-Forwarded-Host $host;
				proxy_set_header   X-Forwarded-Proto $scheme;
				proxy_redirect     off;
				proxy_http_version 1.1;
				proxy_set_header   Upgrade $http_upgrade;
				proxy_set_header   Connection $http_connection;
			'';
		};

		locations."/sonarr/api" = {
			proxyPass = "http://127.0.0.1:8989";
			extraConfig = ''
                auth_basic off;
			'';
		};
	};
}

