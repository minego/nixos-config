{ config, pkgs, lib, ... }:
with lib;

{
	options.services.ombi = {
		publicURL						= lib.mkOption { type = lib.types.str;  };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.ombi = rec {
			port						= 5005;
			publicURL					= "https://ombi.${config.services.nginx.hostname}";
			internalURL					= "http://127.0.0.1:${toString port}";

			enable						= true;
			openFirewall				= true;
			group						= "plex";
		};

		services.nginx.virtualHosts."ombi.${config.services.nginx.hostname}" = {
			forceSSL					= true;

			locations."/" = {
				proxyPass				= config.services.ombi.internalURL;
				proxyWebsockets			= true;
				extraConfig				= "proxy_pass_header Authorization;";
			};

			sslCertificate				= config.services.nginx.sslCertificate;
			sslCertificateKey			= config.services.nginx.sslCertificateKey;
		};
	};
}

