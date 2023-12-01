{ config, pkgs, ... }:
{
	services.plex = {
		enable			= true;
		openFirewall	= true;
		user			= "plex";
		group			= "plex";

		dataDir			= "/var/lib/plex";
	};

	services.nginx.virtualHosts."plex.minego.net" = {
		forceSSL = true;

		locations."/" = {
			proxyPass = "http://127.0.0.1:32400/web/";
			proxyWebsockets = true;
			extraConfig = "proxy_pass_header Authorization;";
		};

		sslCertificate		= "/var/lib/acme/minego.net/fullchain.pem";
		sslCertificateKey	= "/var/lib/acme/minego.net/key.pem";
	};

}

