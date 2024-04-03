{ config, pkgs, lib, ... }:
with lib;

{
	options.services.sabnzbd = {
		port							= lib.mkOption { type = lib.types.port; };
		publicURL						= lib.mkOption { type = lib.types.str;  };
		internalURL						= lib.mkOption { type = lib.types.str;  };
	};

	config = {
		services.sabnzbd = rec {
			port						= 8080;
			internalURL					= "http://127.0.0.1:${toString port}";
			publicURL					= "http://sabnzbd.${config.services.nginx.hostname}";

			enable						= true;
			group						= "plex";
			configFile					= "/var/lib/sabnzbd/sabnzbd.ini";
		};

		networking.firewall.allowedTCPPorts = [ 8080 9090 ];

		environment.systemPackages = with pkgs; [
			par2cmdline
		];

		# Wait until after nginx to start
		systemd.services.sabnzbd.after = [ "network.target" "nginx.service" ];

		services.nginx.virtualHosts."sabnzbd.${config.services.nginx.hostname}" = {
			forceSSL					= true;

			locations."/" = {
				proxyPass				= config.services.sabnzbd.internalURL;
				proxyWebsockets			= true;
				extraConfig				= "proxy_pass_header Authorization;";
			};

			sslCertificate				= config.services.nginx.sslCertificate;
			sslCertificateKey			= config.services.nginx.sslCertificateKey;
		};
	};
}
