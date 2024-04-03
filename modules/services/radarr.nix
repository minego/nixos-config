{ config, pkgs, lib, ... }:
with lib;

{
	options.services.radarr = {
		port							= lib.mkOption { type = lib.types.port; };
		publicURL						= lib.mkOption { type = lib.types.str;  };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.radarr = rec {
			port						= 7878;
			publicURL					= "https://radarr.${config.services.nginx.hostname}";
			internalURL					= "http://127.0.0.1:${toString port}";

			enable						= true;
			openFirewall				= true;
			group						= "plex";
		};

		services.nginx.virtualHosts."radarr.${config.services.nginx.hostname}" = {
			forceSSL					= true;

			locations."/" = {
				proxyPass				= config.services.radarr.internalURL;
				proxyWebsockets			= true;
				extraConfig				= "proxy_pass_header Authorization;";
			};

			sslCertificate				= config.services.nginx.sslCertificate;
			sslCertificateKey			= config.services.nginx.sslCertificateKey;
		};
	};
}

