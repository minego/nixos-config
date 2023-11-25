{ config, pkgs, ... }:
{
	services.nginx.enable = true;

	services.nginx.virtualHosts."minego.net" = {
		forceSSL			= true;
		# enableACME			= true;

		locations."/" = {
			root			= "/var/www/minego.net";
		};

		serverAliases		= [
			"minego.net"
			"www.minego.net"
			"micahgorrell.com"
			"www.micahgorrell.com"
		];

		sslCertificate		= "/var/lib/acme/minego.net/fullchain.pem";
		sslCertificateKey	= "/var/lib/acme/minego.net/key.pem";
	};
	security.acme = {
		acceptTerms			= true;
		defaults = {
			email			= "m@minego.net";
			credentialFiles	= {
				CLOUDFLARE_EMAIL_FILE	= "/var/lib/secrets/cloudflare.email";
				CLOUDFLARE_API_KEY_FILE	= "/var/lib/secrets/cloudflare.key";
			};
		};

		certs."minego.net" = {
			domain			= "*.minego.net";
			dnsProvider		= "cloudflare";
			group			= "nginx";
		};
	};

	# Open ports
	networking.firewall.allowedTCPPorts = [ 80 443 ];
}

