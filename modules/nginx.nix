{ config, pkgs, ... }:
{
	services.nginx = {
		enable					= true;

		recommendedProxySettings= true;
		recommendedTlsSettings	= true;
		recommendedGzipSettings	= true;

		virtualHosts."minego.net" = {
			forceSSL			= true;
			default				= true;
			root				= "/var/www/minego.net/";

			locations."/" = {
			};

			locations."/.videos/Movies/" = {
				alias			= "/data/Movies/";
				extraConfig		= "autoindex on;";
			};

			locations."/.videos/TV/" = {
				alias			= "/data/TV/";
				extraConfig		= "autoindex on;";
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
			extraDomainNames= [ "minego.net" ];
		};
	};

	# Open ports
	networking.firewall.allowedTCPPorts = [ 80 443 ];
}

