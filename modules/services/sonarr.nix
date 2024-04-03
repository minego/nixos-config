{ config, pkgs, lib, ... }:
with lib;

{
	options.services.sonarr = {
		port							= lib.mkOption { type = lib.types.port; };
		publicURL						= lib.mkOption { type = lib.types.str;  };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.sonarr = rec {
			port						= 8989;
			publicURL					= "https://sonarr.${config.services.nginx.hostname}";
			internalURL					= "http://127.0.0.1:${toString port}";

			enable						= true;
			openFirewall				= true;
			group						= "plex";
		};

		services.nginx.virtualHosts."sonarr.${config.services.nginx.hostname}" = {
			forceSSL					= true;

			locations."/" = {
				proxyPass				= config.services.sonarr.internalURL;
				proxyWebsockets			= true;
				extraConfig				= "proxy_pass_header Authorization;";
			};

			sslCertificate				= config.services.nginx.sslCertificate;
			sslCertificateKey			= config.services.nginx.sslCertificateKey;
		};
	};
}

