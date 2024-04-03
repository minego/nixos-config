{ config, pkgs, ... }:
{
	services.radarr = {
		enable			= true;
		openFirewall	= true;
		group			= "plex";
	};

	# Reverse proxy with subdir
    services.nginx.virtualHosts."${config.services.nginx.hostname}" = {
		locations."/radarr" = {
			proxyPass = "http://127.0.0.1:7878";

			extraConfig = ''
				proxy_set_header   Host $host;
				proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
				proxy_set_header   X-Forwarded-Host $host;
				proxy_set_header   X-Forwarded-Proto $scheme;
				proxy_redirect     off;
				proxy_http_version 1.1;
				proxy_set_header   Upgrade $http_upgrade;
				proxy_set_header   Connection $http_connection;
			'';
		};

		locations."/radarr/api" = {
			proxyPass = "http://127.0.0.1:7878";
			extraConfig = ''
                auth_basic off;
			'';
		};
	};

}

