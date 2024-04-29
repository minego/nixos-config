{ config, pkgs, lib, inputs, ... }:
with lib;

# Home Assistant OS reverse proxy
#
# This does not setup HAOS itself. That has to be done in a VM.
{
	options.haos = {
		publicURL						= lib.mkOption { type = lib.types.str;  };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		haos = {
			publicURL					= "https://home.${config.services.nginx.hostname}";
			internalURL					= "http://homeassistant.minego.net:8123";
		};

		services.nginx.virtualHosts."home.${config.services.nginx.hostname}" = {
			forceSSL					= true;

			locations."/" = {
				proxyPass				= config.haos.internalURL;
				proxyWebsockets			= true;
				recommendedProxySettings= true;
				extraConfig				= ''
                    proxy_set_header Upgrade $http_upgrade;
                    proxy_set_header Connection "upgrade";
					proxy_set_header Host $host;
                    '';
			};

			extraConfig = ''
                proxy_buffering off;
                '';

			sslCertificate				= config.services.nginx.sslCertificate;
			sslCertificateKey			= config.services.nginx.sslCertificateKey;
		};

		# Driver needed for the EdgeTPU Coral dev board
		boot.extraModulePackages = with config.boot.kernelPackages; [
			gasket
		];
	};
}

